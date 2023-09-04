
// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.4.22;

contract Report {

    /**
    * addr: 用户账户
    * uint: 信誉分
    * violated: 是否违规
    * amount: 存储的押金数量
    * waterMark: 嵌入的软件水印
    * 
    */
    struct User {
        uint score;
        bool violated;
        uint amount;
        string waterMark;
    }


    string public project;                      // 项目名称
    address private publisher;                  // 合约发布者
    uint private deadline;                      // 项目期限
    address[] private shareHolders;             // 项目股东
    address [] private userAdress;              // 用户地址
    mapping (address => User) users;            // 存储押金的用户

    // 存储押金事件 {用户，金额}
    event Deposit(address user_, uint amount_);
    // 举报侵权事件 {举报人，被举报人，水印}
    event ReportInfringement(address informant_, address suspect_, string waterMark_);
    // 校验水印 {被举报人、水印}
    event CheckWaterMark(address suspect_, string waterMark_);
    // 检查项目是否已经如期结束
    event CompleteProject(string project_);

    // 构造函数 {项目名称，项目截止时间，股东}
    constructor(string memory project_, uint minutes_, address[] memory shareHolder_)  {
        project = project_;
        publisher = msg.sender;
        deadline = block.timestamp + minutes_ * 60;  // mins
        for (uint i = 0; i < shareHolder_.length; i++) {
            shareHolders.push(shareHolder_[i]);
        }
    }

    // 获取项目名称
    function getProject() public view returns(string memory) {
        return project;
    }

    // 增加股东
    function addShareHolder(address shareHolder_) public {
        require(msg.sender == publisher);
        shareHolders.push(shareHolder_);
    }

    // 根据用户信誉确定需要缴纳的押金数
    function getDepositAmount(uint score_) public returns(uint) {
        return 1 ether * (500 - score_) / 100;
    }

    // 存储押金 {用户信誉，水印}
    /**
    * 1. 通过用户的信誉分 score 计算出用户需要存储的押金 amount
    * 2. 用户向合约账户转账 amount
    * 3. 添加用户地址
    * 4. 添加用户信息
    */
    function deposit(uint score_, string memory waterMark_) payable public {
        uint amount = getDepositAmount(score_);
        userAdress.push(msg.sender);
        users[msg.sender].score = score_;
        users[msg.sender].violated = false;
        users[msg.sender].amount = amount;
        users[msg.sender].waterMark = waterMark_;
    
        emit Deposit(msg.sender, amount);
    }

    // 举报违规
    /**
    * 1. 通过 check 函数校验水印，如果校验成功，说明违规嫌疑人违规属实
    * 2. 对告密者进行奖赏
    * 3. 对违规者惩罚
    */
    function report(address suspect_, string memory waterMark_) payable public {
        if (check(suspect_, waterMark_)) {
            reward(msg.sender, suspect_);
            punish(suspect_);
        }

        emit ReportInfringement(msg.sender, suspect_, waterMark_);
    }

    // 校验水印
    /**
    * 1. 如果用户已经核实违规，直接返回 false
    * 2. 如果用户暂未被核实违规，对比用户的水印和告密者提供的水印(采用字符串哈希比较)
    * 3. 若水印吻合，则校验成功，确认违规
    */
    
    function check(address suspect_, string memory waterMark_) private returns(bool) {
       if (!users[suspect_].violated && keccak256(abi.encodePacked(users[suspect_].waterMark)) == keccak256(abi.encodePacked(waterMark_))) {
            emit CheckWaterMark(suspect_, waterMark_);
            return true;
        }
        return false;

    }

   // 对告密者奖励，奖励违规者 5% 的押金
    /**
    * 1. 计算告密者能获得的奖励
    * 2. 给告密者转账
    * 3. 将违规者存储的押金扣除奖励部分
    */
    function reward(address informant_, address suspect_)  private returns(bool){
        uint amount = users[suspect_].amount / 20;
        (bool callSuccess,) = payable(informant_).call{value: amount}("");
        require(callSuccess, "Send failed");
        users[suspect_].amount -= amount;
        return true;
    }

    // 对违规者处罚，将剩余押金分给项目股东
    /**
    * 1. 计算每个股东能分得的押金(均分)
    * 2. 给每个股东转账
    * 3. 将违规者存储在项目账户里的押金数置 0
    * 4. 给违规者标记违规
    */
    function punish(address suspect_) private returns(bool) {
        uint amount = users[suspect_].amount / shareHolders.length;
        for (uint i = 0; i < shareHolders.length; i++) {
            (bool callSuccess,) = payable(shareHolders[i]).call{value: amount}("");
            require(callSuccess, "Send failed");
        }
        users[suspect_].amount = 0;
        users[suspect_].violated = true;
        return true;
    }

    // 检查项目是否如期结束
    /**
    * 1. 检查当前时间是否超过项目设定的截止时间
    * 2. 若超过：将未违规的用户的押金返回
    * 3. 终止合约
    */
    function completeProject() payable public {
        if (block.timestamp >= deadline) {
            for (uint i = 0; i < userAdress.length; i++) {
                if (!users[userAdress[i]].violated) {
                    (bool callSuccess,) = payable(shareHolders[i]).call{value: users[userAdress[i]].amount}("");
                    require(callSuccess, "Send failed");
                }
            }

            emit CompleteProject(project);
        }
    }
}

