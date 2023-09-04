pragma solidity >=0.4.0 <0.9.0;

contract profitDistribution{

    mapping(uint256 => project) private projects;
    uint256[] private projectsKeys;
    uint256 projectID = 0;

    struct project{
        uint256 id;
        string name;
        address creator;
        mapping(address => contributor) contributors;
        uint256 contributorNum;
        address [] allContributors;       //项目所有的贡献者
        uint256 weiPerContri;          // 每获取一贡献度需要贡献的金额
        uint256 perBalance;   // 每次的购买的收益
        uint256 totalBalance;  //项目总收益
        uint256 totalContri;    // 项目总贡献度
    }

    struct contributor {
        address addr;
        bool isIn;
        uint256 contribution;     // 总贡献度
        uint256 contributionRate;      //贡献比率
    }

    // 项目初始化
    function createProject (string memory name, uint256 weiPerContri) public returns(uint256) {
        uint256 id = projectID;
        // 初始化项目
        projects[id].id = id;
        projects[id].name = name;
        projects[id].creator = msg.sender;
        projects[id].weiPerContri = weiPerContri;
        projectsKeys.push(id);
        // 初始化创建者
        projects[id].contributors[msg.sender].addr = msg.sender;
        projects[id].contributors[msg.sender].isIn = true;
        projectID ++;
        return id;
    }

    // 加入项目，购买贡献度
    function joinPro(uint256 id) public payable returns(uint){
        project storage pro = projects[id];
        uint256 contriToBuy = msg.value / pro.weiPerContri;
        if (!projects[id].contributors[msg.sender].isIn)
        {
            projects[id].contributors[msg.sender].isIn = true;
            projects[id].contributors[msg.sender].addr = msg.sender;
            projects[id].contributorNum += 1;
            projects[id].allContributors.push(msg.sender);
        }

        projects[id].contributors[msg.sender].contribution += contriToBuy;
        projects[id].totalContri += contriToBuy;
        //从加入者的账户转入合约当中
        projects[id].totalBalance += msg.value;
        payable(address(this)).transfer(msg.value);
        //payable(address(this)).transfer(msg.value); 
        
        return contriToBuy;
    }

    // 购买项目并触发分配
    function buyProject(uint256 _projectID) public payable {
        projects[_projectID].totalBalance += msg.value;
        projects[_projectID].perBalance = msg.value;
        //从购买人账户转到合约账户中
        payable(address(this)).transfer(msg.value);
        sendBouns(_projectID);
    }

    // 分配收入
    function sendBouns(uint256 _projectID) public payable {
        uint256 proContri = projects[_projectID].totalContri;
        for(uint256 i=0;i<projects[_projectID].contributorNum;i++){
            address add=projects[_projectID].allContributors[i];
            uint256 personalContri = projects[_projectID].contributors[add].contribution;
            address payable _payableAddr = payable( projects[_projectID].contributors[add].addr);
            uint256 bounsAmount =  projects[_projectID].perBalance * personalContri / proContri * 80 / 100;
            //从合约中转到每个贡献者用户中
            (_payableAddr).transfer(bounsAmount);
        }
    }

    fallback() external payable {}
    
    receive() external payable {}

    function getBanlance() view public returns(uint256){
        return (address(this).balance);
    }


}