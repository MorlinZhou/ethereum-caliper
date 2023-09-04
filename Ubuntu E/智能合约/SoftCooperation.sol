pragma solidity >=0.4.0 <0.9.0;

contract SoftCooperation{
    struct contributor{
        address addr;
        uint256 unExecutedContri;
        uint256 executedContri;
        bool isIn;
        uint256 joinTime; 
        
        //mapping(string => bool[]) lineVisible;
    }
    
    struct user{
        string name;
        uint256 id;
        uint256 credit;
    }
    
    struct project{
        uint256 id;
        string name;
        string description;
        address creator;
        address[] contributorsList;
        mapping(address => contributor) contributors;

        uint256 linesBuyContri;     
        uint256 linesCommitContri;  
        uint256 weiPerContri;
        uint256 totalContri;
        uint256 balance;
    
        bool isUsed;
        
        mapping(string => string[]) content;
    }
    
    uint256 projectID;
    mapping(uint256 => project) private projects;
    
    uint256 userID;
    mapping(address => user) private users;

    
    function createUser(string memory name) public returns(uint256){
        require(users[msg.sender].id != 0);
        userID ++;
        uint256 id = userID;
        users[msg.sender].id = id;
        users[msg.sender].credit = 100;
        users[msg.sender].name = name;
        return id;
    }
    
    // 项目初始化
    function createProject (string memory name, string memory des,
                        uint256 linesBuyContri,uint256 linesCommitContri,
                        uint256 weiPerContri) public returns(uint256) {
        projectID ++;
        uint256 id = projectID;
        // 初始化项目
        projects[id].id = id;
        projects[id].name = name;
        projects[id].description = des;
        projects[id].linesBuyContri = linesBuyContri;
        projects[id].linesCommitContri = linesCommitContri; 
        projects[id].weiPerContri = weiPerContri;
        projects[id].isUsed = true;
        projects[id].creator = msg.sender;
        // 初始化创建者
        projects[id].contributors[msg.sender].addr = msg.sender;
        projects[id].contributors[msg.sender].joinTime = block.timestamp;
        projects[id].contributors[msg.sender].isIn = true;
        projects[id].contributorsList.push(msg.sender);
        return id;
    }
    
    function getContriByBuy(uint256 projectid) payable returns(uint256){
        require(projects[projectid].isUsed == true);
        require(msg.value >= projects[projectid].weiPerContri);
        this.transfer(msg.value); 
        
        uint256 value=msg.value;
        uint256 contri=value/projects[projectid].weiPerContri;
        //profitDistribution(projectid,msg.value);
        
        projects[projectid].balance += value;
        uint256 totalContri = projects[projectid].totalContri;
        uint256 profitValue = value*4/5;
        for (uint i=0;i<projects[projectid].contributorsList.length;i++){
            address c=projects[projectid].contributorsList[i];
            uint256 unexeContri=projects[projectid].contributors[c].unExecutedContri;
            uint256 exeContri=projects[projectid].contributors[c].executedContri;
            uint256 profit=profitValue*(unexeContri+exeContri)/totalContri;
            (c).transfer(profit);
            projects[projectid].balance-=profit;
        }
        
        if (projects[projectid].contributors[msg.sender].isIn == false){
            participate(projectid,msg.sender,contri);
        } 
        else {
            projects[projectid].contributors[msg.sender].unExecutedContri+=contri;
            projects[projectid].totalContri+=contri;
        }
        return contri;
    }
    
    function getContriByCommit(uint256 projectid,string memory fileName,string memory content) public returns(uint256){
        require(projects[projectid].isUsed == true);
        string[] contentByLine;
        contentByLine[0]='';
        uint256 lines=1;
        bytes memory arr=bytes(content);
        for (uint256 i=0;i<arr.length;i++){
            if (bytes(content)[i]=='\n') {
                contentByLine[lines]='';
                lines++;
            }else contentByLine[lines-1]=concat(contentByLine[lines-1],arr[i]);
        }
        uint256 contri=lines*projects[projectid].linesCommitContri;
        modifyContent(msg.sender,projectid,fileName,contentByLine,contri);
        //delete contentByLine;
        return contri;
    }
    
    
    function exchangeCode(uint256 projectid,uint256 lines,string memory fileName,uint startLine) public returns(string){
        require(projects[projectid].isUsed == true);
        require(projects[projectid].contributors[msg.sender].isIn == true);
        
        uint256 contriReq=lines*projects[projectid].linesBuyContri;
        uint256 unexeContri=projects[projectid].contributors[msg.sender].unExecutedContri;
        require(unexeContri >= contriReq);
        
        projects[projectid].contributors[msg.sender].unExecutedContri-=contriReq;
        projects[projectid].contributors[msg.sender].executedContri+=contriReq;
        
        string memory res="";
        uint256 len=projects[projectid].content[fileName].length;
        for (uint i=startLine;i<startLine+lines;i++)
        if (i<len){
            //(projects[projectid].contributors[msg.sender].lineVisible[fileName])[i]=true;
            res=strConcat(res,(projects[projectid].content[fileName])[i]);
        }
        return res;
    }
    
    // function profitDistribution(uint256 projectid, uint256 value) payable{
    //     projects[projectid].balance += value;
    //     uint256 totalContri = projects[projectid].totalContri;
    //     uint256 profitValue = value*4/5;
    //     for (uint i=0;i<projects[projectid].contributorsList.length;i++){
    //         address c=projects[projectid].contributorsList[i];
    //         uint256 unexeContri=projects[projectid].contributors[c].unExecutedContri;
    //         uint256 exeContri=projects[projectid].contributors[c].executedContri;
    //         uint256 profit=profitValue*(unexeContri+exeContri)/totalContri;
    //         c.transfer(profit);
    //         projects[projectid].balance-=profit;
    //     }
    // }
    
    function participate(uint256 projectid,address userAddr,uint256 contri) private {
        require(projects[projectid].contributors[userAddr].isIn == false);
        projects[projectid].contributors[userAddr].addr = userAddr;
        projects[projectid].contributors[userAddr].joinTime = block.timestamp;
        projects[projectid].contributors[userAddr].isIn = true;
        projects[projectid].contributors[userAddr].unExecutedContri=contri;
        projects[projectid].totalContri+=contri;
        projects[projectid].contributorsList.push(userAddr);
    }
    
    function modifyContent(address userAddr,uint256 projectid,string memory fileName,string[] storage content,uint256 contri)private {
        for (uint256 i=0;i<content.length;i++){
            projects[projectid].content[fileName].push(content[i]);
        }
        
        if (projects[projectid].contributors[userAddr].isIn == false){
            participate(projectid,userAddr,contri);
        } 
        else {
            projects[projectid].contributors[userAddr].unExecutedContri+=contri;
            projects[projectid].totalContri+=contri;
        }
        //bool[] storage linesVisible;
        //for (uint256 i=0;i<content.length;i++){
        //    linesVisible.push(true);
        //}
        //projects[projectid].contributors[userAddr].lineVisible[fileName]=linesVisible;
    }
    
    function concat(string a,byte b) private returns(string){
        bytes memory _a = bytes(a);
        uint len=_a.length+1;
        string memory res = new string(len);
        bytes memory bres=bytes(res);
        uint k=0;
        for (uint i = 0; i < _a.length; i++) bres[k++] = _a[i];
        bres[k++]=b;
        return string(bres);
    }
    
    function strConcat(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ret = new string(_ba.length + _bb.length );
        bytes memory bret = bytes(ret);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(ret);
   }  

    function () payable{ 
	} 
    
    function getBanlance()  public returns(uint256){
        return (address(this).balance);
    }

    function getProjectInfo(uint projectid) public returns(string,uint256,uint256){
        return (projects[projectid].name,projects[projectid].balance,projects[projectid].totalContri);
    }
    
    function getContri(uint projectid,address userAddr) public returns(uint,uint){
        return (projects[projectid].contributors[userAddr].unExecutedContri,
        projects[projectid].contributors[userAddr].executedContri);
    }

    function getContributor(uint projectid,uint i) public returns(address){
        return (projects[projectid].contributorsList[i]);
    }

}