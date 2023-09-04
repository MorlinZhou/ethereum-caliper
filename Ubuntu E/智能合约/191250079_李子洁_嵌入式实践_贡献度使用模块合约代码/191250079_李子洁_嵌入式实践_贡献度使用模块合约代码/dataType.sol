// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;

enum requirementImportance { P0, P1, P2 } //需求重要性参数


struct project {
    uint256 id;
    string name;
    address creator;
    address [] allContributors;       //项目所有的贡献者
    uint256 weiPerContribution;          // 每获取一贡献度需要贡献的金额
    uint256 minJoinContribution;   // 加入项目需要购买的贡献度阈值
    uint256 contributionPerLine;    //交换每行代码访问权限所需贡献度
    uint256 totalContribution;    // 项目总贡献度
    uint256 profit;   // 项目收益余额
    mapping(address => contributor) contributors;
    mapping(string => fileContent) codeFiles;  //key为文件名,value为文件内容

}

struct contributor {
    address adr;
    uint256 personalContribution;     // 总贡献度
    uint256 unusedContribution;          // 未执行贡献度
    uint256 lastBounsTime;  
    uint256 obtainedBonus;      //已获得Bonus
    bool isIn;
    bool isOwner;
    uint256 joinTime;         // 用户加入项目的时间
}

struct fileContent{
    uint256 totalLength;
    string[] content;
    bool isExist;
}