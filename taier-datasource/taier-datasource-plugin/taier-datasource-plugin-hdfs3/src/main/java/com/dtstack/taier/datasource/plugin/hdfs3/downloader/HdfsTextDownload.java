/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.dtstack.taier.datasource.plugin.hdfs3.downloader;

import com.dtstack.taier.datasource.plugin.common.utils.HiveUtil;
import com.dtstack.taier.datasource.plugin.common.utils.ListUtil;
import com.dtstack.taier.datasource.plugin.kerberos.core.hdfs.HdfsOperator;
import com.dtstack.taier.datasource.plugin.kerberos.core.util.KerberosLoginUtil;
import com.dtstack.taier.datasource.api.downloader.IDownloader;
import com.dtstack.taier.datasource.api.exception.SourceException;
import com.google.common.collect.Lists;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.InputSplit;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.RecordReader;
import org.apache.hadoop.mapred.Reporter;
import org.apache.hadoop.mapred.TextInputFormat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.security.PrivilegedAction;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * ??????hdfs????????????????????????text??????
 *
 * @author ???wangchuan
 * date???Created in ??????01:50 2020/8/11
 * company: www.dtstack.com
 */

public class HdfsTextDownload implements IDownloader {
    private static final int SPLIT_NUM = 1;

    private static final String IMPALA_INSERT_STAGING = "_impala_insert_staging";

    private TextInputFormat inputFormat;
    private JobConf conf;
    private LongWritable key;
    private Text value;

    private RecordReader recordReader;
    private final String tableLocation;
    private final String fieldDelimiter;
    private final Configuration configuration;
    private final List<String> columnNames;

    // ???????????????????????????
    private final List<Integer> needIndex;

    private List<String> paths;
    private String currFile;
    private int currFileIndex = 0;

    private InputSplit[] splits;
    private int splitIndex = 0;
    private final List<String> partitionColumns;
    private final Map<String, Object> kerberosConfig;

    /**
     * ???????????????
     */
    private final Map<String, String> filterPartition;

    /**
     * ????????????
     */
    private final List<String> partitions;

    /**
     * ??????????????????
     */
    private List<String> currentPartData;

    private static final String SCHEMA_FILE_PATH = "/.metastore/schema";

    public HdfsTextDownload(Configuration configuration, String tableLocation, List<String> columnNames, String fieldDelimiter,
                            List<String> partitionColumns, Map<String, String> filterPartition, List<Integer> needIndex,
                            List<String> partitions, Map<String, Object> kerberosConfig){
        this.tableLocation = tableLocation;
        this.columnNames = columnNames;
        this.fieldDelimiter = fieldDelimiter;
        this.partitionColumns = partitionColumns;
        this.configuration = configuration;
        this.filterPartition = filterPartition;
        this.kerberosConfig = kerberosConfig;
        this.partitions = partitions;
        this.needIndex = needIndex;
    }

    @Override
    public boolean configure() throws IOException {

        conf = new JobConf(configuration);
        paths = Lists.newArrayList();
        FileSystem fs =  FileSystem.get(conf);
        // ????????????????????????????????????
        getAllPartitionPath(tableLocation, paths, fs);
        // ????????? columnNames, ????????????????????? schema ??????
        readFromFileIfEmpty(columnNames, fs);
        // ???????????????????????????metaStore????????????????????????????????????????????????????????????
        if(paths.size() == 0){
            return true;
        }
        nextRecordReader();
        key = new LongWritable();
        value = new Text();
        return true;
    }

    /**
     * ??? schema ??????????????????????????????
     *
     * @param columnNames ???????????????
     * @param fs          file system
     */
    private void readFromFileIfEmpty(List<String> columnNames, FileSystem fs) throws IOException {
        if (CollectionUtils.isNotEmpty(columnNames)) {
            return;
        }
        String path = tableLocation + SCHEMA_FILE_PATH;
        Path schemaPath = new Path(path);
        if (!fs.exists(schemaPath) || fs.getFileStatus(schemaPath).getLen() == 0) {
            throw new SourceException(String.format("column schema file path %s is not exists or size is 0", schemaPath));
        }

        try (FSDataInputStream is = fs.open(schemaPath);
             BufferedReader d = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String lineStr;
            //??????????????????????????????????????????
            while ((lineStr = d.readLine()) != null) {
                if (StringUtils.isNotEmpty(lineStr)) {
                    if (lineStr.length() > 1 && lineStr.startsWith("\"") && lineStr.endsWith("\"")) {
                        columnNames.add(lineStr.substring(1, lineStr.lastIndexOf("\"")).trim());
                    } else {
                        columnNames.add(lineStr.trim());
                    }
                }
            }
        }
    }

    /**
     * ????????????????????????????????????????????????????????????????????????
     *
     * @param tableLocation hdfs????????????
     * @param pathList ??????????????????
     * @param fs HDFS ????????????
     */
    public static void getAllPartitionPath(String tableLocation, List<String> pathList, FileSystem fs) throws IOException {
        Path inputPath = new Path(tableLocation);
        // ???????????????????????????
        if (!fs.exists(inputPath)) {
            return;
        }
        //???????????????????????????????????????
        FileStatus[] fsStatus = fs.listStatus(inputPath, path -> !path.getName().startsWith(".") && !path.getName().startsWith("_SUCCESS") && !path.getName().startsWith(IMPALA_INSERT_STAGING) && !path.getName().startsWith("_common_metadata"));
        if(fsStatus == null || fsStatus.length == 0){
            return;
        }
        for (FileStatus status : fsStatus) {
            if (status.isFile()) {
                pathList.add(status.getPath().toString());
            }else {
                getAllPartitionPath(status.getPath().toString(), pathList, fs);
            }
        }
    }

    private boolean nextRecordReader() throws IOException {

        if(!nextFile()){
            return false;
        }

        Path inputPath = new Path(currFile);
        inputFormat = new TextInputFormat();

        FileInputFormat.setInputPaths(conf, inputPath);
        TextInputFormat inputFormat = new TextInputFormat();
        inputFormat.configure(conf);
        splits = inputFormat.getSplits(conf, SPLIT_NUM);
        if(splits.length == 0){
            return nextRecordReader();
        }
        nextSplitRecordReader();
        return true;
    }

    private boolean nextSplitRecordReader() throws IOException {
        if(splitIndex >= splits.length){
            return false;
        }

        InputSplit fileSplit = splits[splitIndex];
        splitIndex++;

        if(recordReader != null){
            close();
        }

        recordReader = inputFormat.getRecordReader(fileSplit, conf, Reporter.NULL);
        return true;
    }

    private boolean nextFile(){
        if(currFileIndex > (paths.size() - 1)){
            return false;
        }

        currFile = paths.get(currFileIndex);

        if(CollectionUtils.isNotEmpty(partitionColumns)){
            currentPartData = HdfsOperator.parsePartitionDataFromUrl(currFile,partitionColumns);
        }

        // ????????????????????????????????????????????????????????????
        if (!isPartitionExists() || !isRequiredPartition()){
            currFileIndex++;
            splitIndex = 0;
            return nextFile();
        }

        currFileIndex++;
        splitIndex = 0;
        return true;
    }

    public boolean nextRecord() throws IOException {

        if(recordReader.next(key, value)){
            return true;
        }

        //?????????????????????????????????????????????split
        while(nextSplitRecordReader()){
            if(nextRecord()){
                return true;
            }
        }

        //?????????????????????????????????
        while (nextRecordReader()){
            if(nextRecord()){
                return true;
            }
        }

        return false;
    }

    @Override
    public List<String> getMetaInfo() {
        List<String> metaInfo = new ArrayList<>(columnNames);
        if(CollectionUtils.isNotEmpty(partitionColumns)){
            metaInfo.addAll(partitionColumns);
        }
        return metaInfo;
    }

    @Override
    public List<String> readNext(){
        return KerberosLoginUtil.loginWithUGI(kerberosConfig).doAs(
                (PrivilegedAction<List<String>>) ()->{
                    try {
                        return readNextWithKerberos();
                    } catch (Exception e){
                        throw new SourceException(String.format("Abnormal reading file,%s", e.getMessage()), e);
                    }
                });
    }

    public List<String> readNextWithKerberos(){
        String line = value.toString();
        value.clear();
        String[] fields = HiveUtil.splitByDelimiterStr(line, fieldDelimiter);
        List<String> row = Lists.newArrayList(fields);
        if(CollectionUtils.isNotEmpty(partitionColumns)){
            row.addAll(currentPartData);
        }
        if (CollectionUtils.isNotEmpty(needIndex)) {
            List<String> rowNew = Lists.newArrayList();
            for (Integer index : needIndex) {
                if (index > row.size() -1) {
                    rowNew.add(null);
                } else {
                    rowNew.add(row.get(index));
                }
            }
            return rowNew;
        }
        return row;
    }

    @Override
    public boolean reachedEnd() {
        return KerberosLoginUtil.loginWithUGI(kerberosConfig).doAs(
                (PrivilegedAction<Boolean>) ()->{
                    try {
                        return recordReader == null || !nextRecord();
                    } catch (Exception e){
                        throw new SourceException(String.format("Download file is abnormal,%s", e.getMessage()), e);
                    }
                });
    }

    @Override
    public boolean close() throws IOException {
        if(recordReader != null){
            recordReader.close();
        }
        return true;
    }

    /**
     * ????????????????????????
     *
     * @return ??????????????????
     */
    private boolean isPartitionExists() {
        // ?????? partitions ??? null?????????????????????????????? true
        if (Objects.isNull(partitions)) {
            return true;
        }
        // ??????????????????????????????????????????????????????????????? false
        if (CollectionUtils.isEmpty(partitions)) {
            return false;
        }
        String curPathPartition = getCurPathPartition();
        if (StringUtils.isBlank(curPathPartition)) {
            return false;
        }
        return ListUtil.containsIgnoreCase(partitions, curPathPartition);
    }

    /**
     * ?????????????????????????????????
     *
     * @return ??????
     */
    private String getCurPathPartition() {
        StringBuilder curPart = new StringBuilder();
        for (String part : currFile.split("/")) {
            if(part.contains("=")){
                curPart.append(part).append("/");
            }
        }
        String curPartString = curPart.toString();
        if (StringUtils.isNotBlank(curPartString)) {
            return curPartString.substring(0, curPartString.length() - 1);
        }
        return curPartString;
    }

    /**
     * ???????????????????????????????????????????????????
     *
     * @return ?????????????????????
     */
    private boolean isRequiredPartition(){
        if (filterPartition != null && !filterPartition.isEmpty()) {
            //????????????????????????????????????
            Map<String,String> partColDataMap = new HashMap<>();
            for (String part : currFile.split("/")) {
                if(part.contains("=")){
                    String[] parts = part.split("=");
                    partColDataMap.put(parts[0],parts[1]);
                }
            }

            Set<String> keySet = filterPartition.keySet();
            boolean check = true;
            for (String key : keySet) {
                String partition = partColDataMap.get(key);
                String needPartition = filterPartition.get(key);
                if (!Objects.equals(partition, needPartition)){
                    check = false;
                    break;
                }
            }
            return check;
        }
        return true;
    }
}
