// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract contributionUse{
	uint256 projectId = 0;
	mapping(uint256 => project) private projects; //all projects

	uint256[] contributionInfos;

	//项目初始化
	function createProject(string memory _name, uint256 weiperContribution, uint256 min_entry) public {
		uint256 id = projectId;
        projects[id].id = id;
        projects[id].name = _name;
        projects[id].creator = msg.sender;
        projects[id].weiPerContribution = weiperContribution;
        projects[id].minEntry = min_entry;

        //把创建者加入项目
        projects[id].allContributors.push(msg.sender);
        projects[id].contributors[msg.sender].adr = msg.sender;
        projects[id].contributors[msg.sender].isIn = true;
        projects[id].contributors[msg.sender].joinTime = block.timestamp;
        projectId++;
	}

	//获得项目信息
	function getProjectInfo(uint256 project_id) public view returns(uint id, string memory name, address creator, address [] memory allContributors, uint256 weiPerContribution, uint256 minEntry, uint256 totalContribution, uint256 profit ,uint codeNums){
        project storage example=projects[project_id];
        return (example.id, example.name, example.creator, example.allContributors, example.weiPerContribution, example.minEntry, example.totalContribution, example.profit,example.codeNums);
    }

    //购买贡献度
    function buyContribution(uint256 project_id) public payable returns(uint){
    	project storage pro= projects[project_id];
        require(pro.contributors[msg.sender].isIn,"join the project first");
    	uint256 contriToBuy = msg.value / pro.weiPerContribution;
    	payable(address(this)).transfer(msg.value);
        pro.totalContribution += contriToBuy;
        projects[project_id].contributors[msg.sender].contribution += contriToBuy;
        projects[project_id].contributors[msg.sender].balance += contriToBuy;
    	return contriToBuy;
    }

    //加入项目
    function joinProject(uint256 project_id) public payable returns(address[] memory){
        uint256 contriToBuy = msg.value / projects[project_id].weiPerContribution;
        require(contriToBuy >= projects[project_id].minEntry,"buy more contribution");
        payable(address(this)).transfer(msg.value);
        projects[project_id].allContributors.push(msg.sender);
        projects[project_id].totalContribution += contriToBuy;
        projects[project_id].contributors[msg.sender].adr = msg.sender;
        projects[project_id].contributors[msg.sender].isIn = true;
        projects[project_id].contributors[msg.sender].joinTime = block.timestamp;
        projects[project_id].contributors[msg.sender].contribution = contriToBuy;
        projects[project_id].contributors[msg.sender].balance = contriToBuy;
        for(uint i = 0;i < projects[project_id].codeNums;i++) projects[project_id].contributors[msg.sender].codeEntry.push(false);
        return projects[project_id].allContributors;
    }

    //查看项目贡献度部分相关信息
    function getContributionsInfo(uint256 project_id) public returns(address[] memory contributionsAddress, uint256[] memory contributions){
        project storage pro=projects[project_id];
        address[] memory contributorsAddr = pro.allContributors;
        for(uint i=0;i<contributorsAddr.length;i++){
            //当前贡献者地址
            address curContriAddr = contributorsAddr[i];
            contributionInfos.push(pro.contributors[curContriAddr].contribution);
        }
        return (contributorsAddr,contributionInfos);
    }
  


    //初始化代码访问价格
    function initCodePrice(uint256 project_id,uint256 nums,uint256 price) public {
        for(uint i = 0;i < nums;i++){
            projects[project_id].codePrice.push(price);
            address[] memory contributorsAddr = projects[project_id].allContributors;
            for(uint j=0;j<contributorsAddr.length;j++){
            //当前贡献者地址
            address curContriAddr = contributorsAddr[i];
            projects[project_id].contributors[curContriAddr].codeEntry.push(false);
            }
        }
        projects[project_id].codeNums = nums;
        

    }
    //修改代码访问价格
    function changePrice(uint256 project_id,uint256 pos, uint256 price) public {
        require(projects[project_id].codePrice.length > pos,"overfolw");
        projects[project_id].codePrice[pos] = price;
    }
    //添加代码
    function addCode(uint price,uint project_id) public {
        project storage pro=projects[project_id];
        address[] memory contributorsAddr = pro.allContributors;
        pro.codeNums++;
        pro.codePrice.push(price);
        for(uint i=0;i<contributorsAddr.length;i++){
            //当前贡献者地址
            address curContriAddr = contributorsAddr[i];
            pro.contributors[curContriAddr].codeEntry.push(false);
        }
    }

    //交换代码访问权限
    function buyCodeEntry(uint256 project_id,uint256 goalCode) public {
        require(projects[project_id].contributors[msg.sender].isIn,"not in project");
        require(goalCode < projects[project_id].codeNums,"access invalid");
        require(projects[project_id].contributors[msg.sender].balance >= projects[project_id].codePrice[goalCode],"your contribution is not enough");
        projects[project_id].contributors[msg.sender].balance -= projects[project_id].codePrice[goalCode];
        projects[project_id].contributors[msg.sender].codeEntry[goalCode] = true;
    

    }
    //查看是否购买成功
    function accessCode(uint256 project_id,uint256 goalCode) public view returns(uint256 balance){
        require(projects[project_id].contributors[msg.sender].isIn,"not in project");
        require(goalCode < projects[project_id].codeNums,"access invalid");
        require(projects[project_id].contributors[msg.sender].codeEntry[goalCode],"not accessible");
        return projects[project_id].contributors[msg.sender].balance;
    }



    fallback() external payable {}
    
    receive() external payable {}

}

struct project {
    uint256 id;
    string name;
    address creator;
    mapping(address => contributor) contributors;

    address [] allContributors;       // 项目所有的贡献者
    uint256 weiPerContribution;       // 每获取一贡献度需要贡献的金额
    uint256 minEntry;                 // 项目最低准入
    uint256 totalContribution;        // 项目总贡献度
    uint256 profit;                   // 项目收益余额
    uint256 codeNums;
    uint256[] codePrice;
}

struct contributor {
    address adr;
    uint256 contribution;        // 总贡献度
    uint256 balance;             // 未执行贡献度
    uint256 credit;              // 信誉分
    uint256 creditRating;        // 信用等级 
    uint256 lastBounsTime;  
    uint256 obtainedBonus;       // 已获得Bonus
    bool isIn;                   
    uint256 joinTime;            // 用户加入项目的时间

    bool[] codeEntry;
}


