package com.sciatta.hadoop.mapreduce.example.inputformat.custom;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

/**
 * Created by yangxiaoyu on 2020/1/26<br>
 * All Rights Reserved(C) 2017 - 2020 SCIATTA<br><p/>
 * CustomSequenceFileMain
 */
public class CustomSequenceFileMain {
    public static void main(String[] args) throws Exception {
        Tool tool;
        if (args.length == 0) {
            tool = new CustomSequenceFileJobLocal();
        } else if (args[0] != null && args[0].equalsIgnoreCase("cluster")) {
            tool = new CustomSequenceFileJobCluster();
        } else if (args[0] != null && args[0].equalsIgnoreCase("local")) {
            tool = new CustomSequenceFileJobLocal();
        } else {
            throw new IllegalArgumentException("cluster or local");
        }

        int test = ToolRunner.run(new Configuration(), tool, args);
        System.exit(test);
    }
}