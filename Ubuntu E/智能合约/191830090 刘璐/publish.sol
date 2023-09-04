// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.0 <0.9.0;

// @title A contract for publish software
// @author liulu
contract Publish{

    struct Shareholder{
        address payable addr; // 股东的收款地址
        string name;
        uint weight; // 股东权重。小于100,和为100
    }

    struct Product{
        uint256 id; // 代表软件
        string waterMark; // 水印
    }

    struct User{
        address addr;
        uint256 buyTime;
    }

    address payable owner;  // 合约发起者
    Product product;

    mapping(uint => Shareholder) holderMap;
    mapping(uint => User) userMap;

    uint price; // 单位：100 wei
    uint holderNum; // 股东总数量
    uint userNum; // 软件购买者数量

    // 构造方法 
    // 参数：股东发布出版合约时必须填写的内容
    constructor(address payable[] memory _addrs, string[] memory _names, uint[] memory _weight, uint256 _pid, uint _price) {
        require((_addrs.length == _names.length) && (_names.length == _weight.length));
        // 验证权重和
        price = _price;
        holderNum = _addrs.length;
        userNum = 0;

        string memory waterMark = "copyright:";
        // 在水印中存储带所有股东的版权信息
        for(uint i=0; i<holderNum; i++){
            holderMap[i] = Shareholder(_addrs[i], _names[i], _weight[i]);
            waterMark = strConcat(waterMark, _names[i]);
        }

        product = Product(_pid, waterMark);

        owner = payable(msg.sender);
    }

    //验证用户输入金额是否合适
    modifier moneyCheck(uint _price){
         require(msg.value == _price*100,
            "Transaction amount error!");
        _;
    }

    // 用户购买软件
    function buy() payable public moneyCheck(price) returns(Product memory){
        // 按股东权重分配金额
        for(uint i=0; i<holderNum; i++){
            Shareholder memory temp = holderMap[i];
            address payable sowner = temp.addr;
            uint weight = temp.weight;
            // 将金额从合约账户转到股东账户
            sowner.transfer(price*weight); 
        }

        // 记录购买者
        userMap[userNum++] = User(msg.sender, block.timestamp);

        // 生成发给购买用户的软件副本（带有购买者水印）
        Product memory rproduct = product;
        string memory infoMark = addrToStr(msg.sender);
        rproduct.waterMark = strConcat(product.waterMark, infoMark);
        
        return rproduct;
    }



    // 地址转换成字符串 (address -> string)
    function addrToStr(address addr) internal pure returns (string memory) {
        return bytesToStr(abi.encodePacked(addr));
    }

    // Bytes转换成字符串 (bytes -> string)
    function bytesToStr(bytes memory data) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < data.length; i++) {
            str[2 + i * 2] = alphabet[uint256(uint8(data[i] >> 4))];
            str[3 + i * 2] = alphabet[uint256(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    // 字符串拼接
    function strConcat(string memory _a, string memory _b) internal pure returns(string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);

        string memory ret = new string(_ba.length+_bb.length);
        bytes memory bret = bytes(ret);

        uint k=0;
        for(uint i=0; i<_ba.length; i++){
            bret[k++] = _ba[i];
        }
        for(uint i=0; i<_bb.length; i++){
            bret[k++] = _bb[i];
        }

        return string(ret);
    }
}