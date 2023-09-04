// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.0 <0.9.0;

import "./dataType.sol";

contract Trade{
    mapping(uint256 => project)  projects;
    uint256 public projectID =0;

    constructor(){
        createProject(0,0,0,0,0,0,10000,100,0,0,0);
        projects[0].name="test project";
    }

        //项目初始化
    function createProject ( uint256 voteInvolvedRate, uint256 voteAdoptedRate, 
        uint256 applyDuration, uint256 modifyDuration, uint256 codeReviewDuration, 
        uint256 linesCommitPerContri, uint256 weiPerContri, uint256 linesBuyPerContri, 
        uint256 contriThreshold, uint256 entryThreshold , uint256 bounsRate) public returns(uint256) {
        uint256 id = projectID;
        // 初始化项目
        projects[id].id = id;
        projects[id].isUsed = true;   // 预防引用问题
        projects[id].voteInvolvedRate = voteInvolvedRate;
        projects[id].voteAdoptedRate = voteAdoptedRate;
        projects[id].applyDuration = applyDuration;
        projects[id].modifyDuration = modifyDuration;
        projects[id].codeReviewDuration = codeReviewDuration;
        projects[id].linesCommitPerContri = linesCommitPerContri;
        projects[id].linesBuyPerContri = linesBuyPerContri;
        projects[id].weiPerContri = weiPerContri;
        projects[id].contriThreshold = contriThreshold;
        projects[id].entryThreshold = entryThreshold;
        projects[id].creator = msg.sender;
        projects[id].bounsRate = bounsRate;
        // 初始化创建者
        projects[id].contributors[msg.sender].addr = msg.sender;
        projects[id].contributors[msg.sender].joinTime = block.timestamp;
        projects[id].contributors[msg.sender].credit = 100;
        projects[id].contributors[msg.sender].isIn = true;
        projects[id].allContributors.push(msg.sender);
        projectID ++;
        return id;
    }

    function buy(uint256 projectId) public payable{
        profitDistribute(projectId,msg.value);
    }

    function buyContribution(uint256 projectId) public payable{
        project storage pro =projects[projectId];
        uint256 contriToBuy = msg.value / pro.weiPerContri;//可以购买的贡献度
        if(!projects[projectId].contributors[msg.sender].isIn){//如果不在这个项目里面
            require(msg.value >= projects[projectId].entryThreshold);
            projects[projectId].contributors[msg.sender].isIn = true;
            projects[projectId].contributors[msg.sender].joinTime = block.timestamp;
            projects[projectId].contributors[msg.sender].credit = 100;
            projects[projectId].contributors[msg.sender].addr = msg.sender;
            projects[projectId].allContributors.push(msg.sender);
        }
        projects[projectId].contributors[msg.sender].contribution += contriToBuy;
        projects[projectId].contributors[msg.sender].balance += contriToBuy;
        projects[projectId].totalContri += contriToBuy;
        projects[projectId].profitBalance += msg.value;
        // profitDistribute(projectId,msg.value);
    }

    function profitDistribute(uint256 projectId, uint256 profit) private{
        uint256 totalContri = projects[projectId].totalContri;
        for(uint i=0;i<projects[projectId].allContributors.length;i++){
            address contributorAddr = projects[projectId].allContributors[i];
            uint256 salary = projects[projectId].contributors[contributorAddr].contribution * profit / totalContri * 4 / 5;
            payable(contributorAddr).transfer(salary);
            projects[projectId].profitBalance -=salary;
        }
    }

}