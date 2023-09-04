// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0 <0.9.0;

import "./dataType.sol";

contract ContributionUsage{
    //项目ID
    uint256 projectId = 0;
    //所有项目
    mapping(uint256 => project) private projects;

    //创建项目
    function createProject(string memory _name, uint256 _weiPerContribution, uint256 _minJoinContribution,
     uint256 _contributionPerLine) public{
        uint256 id = projectId;
        projects[id].id = id;
        projects[id].name = _name;
        projects[id].creator = msg.sender;
        projects[id].weiPerContribution = _weiPerContribution;
        projects[id].minJoinContribution = _minJoinContribution;
        projects[id].contributionPerLine = _contributionPerLine;
        //把创建者加入项目
        projects[id].allContributors.push(msg.sender);
        projects[id].contributors[msg.sender].adr = msg.sender;
        projects[id].contributors[msg.sender].isIn = true;
        projects[id].contributors[msg.sender].isOwner = true;
        projects[id].contributors[msg.sender].joinTime = block.timestamp;
        projectId++;
    }

    modifier isExist(uint256 _projectId){
        require(_projectId<projectId,"The current project does not exist");
        _;
    }

    //加入项目
    function joinProject(uint256 _projectId) public payable isExist(_projectId) returns(address[] memory){
        project storage pro=projects[_projectId];
        require(pro.contributors[msg.sender].isIn==false,"You have joined the project");
        //第一种方式，通过购买软件加入项目
        uint256 contriAmount = msg.value/pro.weiPerContribution;
        require(contriAmount >= pro.minJoinContribution,"The purchase contribution is too less");
        payable(address(this)).transfer(msg.value);
        pro.profit += msg.value;
        //调用分配利润方法
        profitDistribution(_projectId);
        //更新projecet信息
        pro.allContributors.push(msg.sender);
        pro.totalContribution += contriAmount;
        pro.contributors[msg.sender].adr = msg.sender;
        pro.contributors[msg.sender].isIn = true;
        pro.contributors[msg.sender].isOwner = false;
        pro.contributors[msg.sender].joinTime = block.timestamp;
        pro.contributors[msg.sender].personalContribution += contriAmount;
        pro.contributors[msg.sender].unusedContribution += contriAmount;
        return pro.allContributors;
    }

    function addFile(uint256 _projectId,string memory _fileName,string[] memory _fileContent) public isExist(_projectId){
        project storage pro = projects[_projectId];
        require(pro.contributors[msg.sender].isOwner,"Only owner can execute this method");
        require(pro.codeFiles[_fileName].isExist==false,"The file name already exists");
        pro.codeFiles[_fileName].totalLength = _fileContent.length;
        pro.codeFiles[_fileName].content = _fileContent;
        pro.codeFiles[_fileName].isExist = true;
    }

    //购买贡献度
    function purchaseContribution(uint256 _projectId) public payable isExist(_projectId){
        project storage pro=projects[_projectId];
        require(pro.contributors[msg.sender].isIn,"Please join the project first");
        uint256 contriAmount = msg.value/pro.weiPerContribution;
        payable(address(this)).transfer(msg.value);
        pro.profit += msg.value;
        pro.totalContribution += contriAmount;
        pro.contributors[msg.sender].personalContribution += contriAmount;
        pro.contributors[msg.sender].unusedContribution += contriAmount;
    } 

    /**
     * 交换代码访问权限
     */
    function ExchangeCodeAccess(uint256 _projectId,string memory _fileName,uint256 startLine,uint256 lines) 
    public isExist(_projectId) returns(string[] memory _obtainedContent){
        project storage pro=projects[_projectId];
        require(pro.contributors[msg.sender].isIn,"Please join the project first");
        require(pro.codeFiles[_fileName].isExist,"The file does not exist");
        uint256 unusedContribution = pro.contributors[msg.sender].unusedContribution;
        uint256 neededContribution = lines * pro.contributionPerLine;
        require(unusedContribution >= neededContribution,"Insufficient unexecuted contributions");
        require(startLine+lines-1 <= pro.codeFiles[_fileName].totalLength,
        "The number of currently selected lines exceeds the file length limit");
        string[] memory obtainedContent = new string[](lines);
        for(uint256 fileContentIdx = 0; fileContentIdx < lines; fileContentIdx++){
            obtainedContent[fileContentIdx] = pro.codeFiles[_fileName].content[startLine+fileContentIdx-1];
        }
        pro.contributors[msg.sender].unusedContribution -= neededContribution;
        return obtainedContent;
    }

    /** 
     * 每次用户购买软件时，调用此方法分配利润
     * @param _projectID 项目id
     */
    function profitDistribution(uint256 _projectID) public payable isExist(_projectID){
        project storage pro=projects[_projectID];
        address[] memory contributionAddr = pro.allContributors;
        uint256 proContri = pro.totalContribution;
        if(proContri>0){
        //给当前项目下的每一个贡献者分配利润
        for(uint i=0;i<contributionAddr.length;i++){
            //当前贡献者地址
            address curContriAddr = contributionAddr[i];
            //if(curContriAddr == pro.creator){
            //    continue;
            //}
            //当前贡献者总共贡献度
            uint256 personalContri = pro.contributors[curContriAddr].personalContribution;
            address payable _payableAddr = payable(curContriAddr);
            uint256 bounsAmount = msg.value * 8 / 10 * personalContri / proContri;
            (_payableAddr).transfer(bounsAmount);
            pro.contributors[curContriAddr].lastBounsTime = block.timestamp;
            pro.contributors[curContriAddr].obtainedBonus += bounsAmount;
        }
        //从项目的收益余额扣除已分配的80%的收入（假设所有收入在调用该方法前已存入项目收益余额）
        pro.profit -= msg.value * 8 / 10;
        }
    }


    //当前有多少个项目
    function getProjectAmount() public view returns(uint projectAmount){
        return projectId;
    }

    //获得某个项目的基本信息
    function getProjectInfo(uint256 _projectId) public view isExist(_projectId) returns(uint id, string memory name, address creator, address [] memory allContributors, uint256 weiPerContribution, uint256 minJoinContribution,uint contributionPerLine, uint256 totalContribution, uint256 profit){
        project storage pro=projects[_projectId];
        return (pro.id, pro.name, pro.creator, pro.allContributors, pro.weiPerContribution, pro.minJoinContribution, pro.contributionPerLine, pro.totalContribution, pro.profit);
    }

    //获得某个项目所有贡献者的贡献度信息
    function getContributionsInfo(uint256 _projectId) public view isExist(_projectId) returns(address[] memory contributionsAddress, uint256[] memory contributions){
        project storage pro=projects[_projectId];
        address[] memory contributorsAddr = pro.allContributors;
        uint256[] memory contributionList = new uint256[](contributorsAddr.length);
        for(uint256 i=0;i<contributorsAddr.length;i++){
            //当前贡献者地址
            address curContriAddr = contributorsAddr[i];
            contributionList[i] = pro.contributors[curContriAddr].personalContribution;
        }
        return (contributorsAddr,contributionList);
    }

    //获得项目下某个贡献者的信息
    function getContributorsInfo(uint256 _projectId, address contributorAddress) public view isExist(_projectId) returns(uint256 personalContribution,uint256 unusedContribution, uint256 lastBounsTime, uint256 obtainedBonus){
        require(projects[_projectId].contributors[contributorAddress].isIn,"The current contributor is not in the project");
        project storage pro=projects[_projectId];
        contributor storage ctr = pro.contributors[contributorAddress]; 
        return (ctr.personalContribution,ctr.unusedContribution,ctr.lastBounsTime,ctr.obtainedBonus);
    }

    //获得项目下的某个文件的内容
    function getFileContent(uint256 _projectId, string memory _fileName) public view isExist(_projectId) returns(string[] memory _obtainedContent){
        project storage pro=projects[_projectId];
        uint256 lines = pro.codeFiles[_fileName].totalLength;
        string[] memory obtainedContent = new string[](lines);
        for(uint256 fileContentIdx = 0; fileContentIdx < lines; fileContentIdx++){
            obtainedContent[fileContentIdx] = pro.codeFiles[_fileName].content[fileContentIdx];
        }
        return obtainedContent;
    }

    fallback() external payable {}
    
    receive() external payable {}
}