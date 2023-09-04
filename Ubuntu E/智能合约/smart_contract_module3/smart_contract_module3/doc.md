# 智能合约模块三说明文档

191250142 王一辉

## Part1. 思路与讲解

### I. 实现需求

1. 用户的信誉分初始为100，无黑历史，只有非常优秀的用户才能增长信誉分，正常的用户信誉分不会变化；
2. 参与某项目达到1个月且有一定量提交、购买一定量源代码等，这些条件都具备的时候才会增加0.1-1信誉分。
3. 增加信誉分是一个漫长且较难的过程，信誉分应该设上限200，需要5年时间才能到200，分段式，前期容易增加信誉分，越往后越难，增长速率越来越慢，100-110半年，110-150三年，150-180十年，180-200五十年。
4. 在恶意申请，或者恶意审批，或提交无用代码时，由仲裁委员会(社区信誉度最高的十个人)确认恶意严重程度，根据严重程度降低信誉分，降低1-10分；
5. 当低于50分无法继续参与项目，需要提交材料申诉以期能够回到60，第二次低于50就无法再参与项目；

### II. 问题分析

**第一个核心问题**：信誉分增长如何实现。

信誉分的增长与预期时间相关，在这里我假设一个用户最快的增长幅度不能超过需求，也就是说假设一个用户每个星期都可以获得信誉分的增长，那么它需要从100～110、110～150……的时间为半年、三年……

**第二个核心问题**：确定仲裁委员会。

在solidity中，并没有原生的排序Map（如Java中的TreeMap），所以需要自行实现。在我的合约中，我使用排序链表进行了相关的实现，对用户的信誉分进行排序。

**第三个核心问题**：多次低于50分如何确定。

采用了一个qulifiable的字典来判断它多少次低于50分，从而来确定它的权限。

### III. 核心代码讲解

#### 排序链表的实现

本合约中排序链表的实现参考了：[Maintaining Sorted List](https://medium.com/bandprotocol/solidity-102-3-maintaining-sorted-list-1edd0a228d83)

思路很简单，即插入排序，时间复杂度为$O(n)$；如下图所示：

![]( https://miro.medium.com/max/1400/0*h6TpdAVjm6YsXZXX )

为了方便链表插入的操作，这里额外维护了一个`_next`Map来记录下一个元素。

```solidity
    function _verifyIndex(address prev, uint newValue, address next) 
        internal view returns(bool) {
        return (prev == GUARD || user2credit[prev] >= newValue)
            && (next == GUARD || newValue > user2credit[next]);
    }

    function _findIndex(uint newValue) internal view returns(address) {
        address candidateAddress = GUARD;
        while(true) {
            if (_verifyIndex(candidateAddress, newValue, _next[candidateAddress]))
                return candidateAddress;
            candidateAddress = _next[candidateAddress];
        }
    }
```

通过以上两个函数来确定，新插入的元素`newValue`究竟应该排在哪个index的位置。

有关于链表的增删改查均基于排序链表和辅助的`_next`等数据结构和函数来进行。

这样以来，确定社区信誉度最高的十个人，就可以用获取最高的Top Ten来解决：

```solidity
function getTopTen() public view returns(address[] memory) {
	require(listSize > 10);
	address[] memory addressLists = new address[](10);
	address currentAddress = _next[GUARD];
	for (uint i = 0; i < 10; i++) {
		addressLists[i] = currentAddress;
		currentAddress = _next[currentAddress];
	}
    return addressLists;
}
```

#### 信誉分增长

```solidity
function incCredit(address _user) public {
	// require(_user.purchase >= purchaseLimit && _user.commitLimit >= 	commitLimit);
	uint credit = user2credit[_user];
    uint16[6] memory bars = [0, 24000, 26400, 36000, 43200, 48000];
    uint8[5] memory incs = [240, 96, 16, 5, 1];
	if (credit < upperLimitCredit) {
		uint i = 0;
		uint j = 1;
		while (j < bars.length) {
			if (bars[i] <= credit && credit < bars[j]) {
				credit += incs[i];
				break;
			}
			i++;
			j++;
		}
		updateScore(_user, credit);
	}
}
```

注：因solidity中不存在浮点数的操作，因此这里统一将分数增大240倍，在get的时候再缩小。

为了简化对区间操作，这里采用了表驱动的写法。我的设计思路是，半年25周的情况下，每周增加0.96分为基准。在需要三年增长的情况下，缩小6倍增长速度变成0.16分/周。同理每周0.05分、0.01分。

#### 扣除信誉分

```solidity
// minus
function decCredit(address _user, uint _dec) public {
    uint credit = user2credit[_user];
    _dec *= 240;
    credit -= _dec;
    // lower than 50.
    if (credit < qualifiedCredit) {
        uint8 isQual = qualifiable[_user];
        qualifiable[_user] = isQual + 1;
    }
    updateScore(_user, credit);
}
```

扣除信誉分，由委员会综合讨论一个扣除的分数提交后进行扣分。

这里在分数低于50以后会进行记录，当低于50次数超过1时，会触发不允许参与项目：

```solidity
function isProjectable(address _user) public returns(bool) {
	return isQualifiable(_user) && (getCredit(_user) >= 50);
}

function isQualifiable(address _user) private returns(bool) {
	return qualifiable[_user] < 2;
}
```

## Part2. 编译、运行、测试

本合约在remix在线平台进行编写编译、运行、测试。并使用了metamask进行测试，因为模块三合约并不涉及以太币交易，因此测试账号没有申请测试货币。

![](https://box.nju.edu.cn/f/4f4be3775b82434b8fae/?dl=1)

自动生成单元测试并编译：

![](https://box.nju.edu.cn/f/a2101cc17e1f41858bb0/?dl=1)

部署之后均可以通过。

#### 编译并运行creditOp.sol

![](/Users/wyh0111jx/Library/Application Support/typora-user-images/image-20221108152516706.png)

首先利用我自己的账户进行测试，测试加入用户和查询用户：

![](https://box.nju.edu.cn/f/b9ece7b73fb54584b0f0/?dl=1)

可以看到运行正常，新加入的用户返回了100分。

测试加分：正常情况下，加分25次才可以达到110分，进行测试：

![](/Users/wyh0111jx/Library/Application Support/typora-user-images/image-20221108153800461.png)

初步实验发现结果符合预期。

测试扣分情况：

![](/Users/wyh0111jx/Library/Application Support/typora-user-images/image-20221108154220522.png)

在分数低于50之后不可以参与项目。

仲裁委员会通过updateCredit进行分数修正：

![](https://box.nju.edu.cn/f/48245715a6a74f308f03/?dl=1)

并且此时可以参加项目：

![](https://box.nju.edu.cn/f/9a62e1bb0fe24699a248/?dl=1)

但第二次低于50之后：

![](https://box.nju.edu.cn/f/168b91f3377c43b0a41a/?dl=1)

便不允许再参与项目。

## Appendix1. 合约代码

```solidity
pragma solidity ^0.7.6;

contract creditOp {
    mapping (address => uint) public user2credit;
    mapping (address => address) _next;
    uint256 public listSize;
    address constant GUARD = address(1);


    mapping (address => uint8) public qualifiable;
    uint256 private initCredit = 24000;
    uint256 private upperLimitCredit = 48000;
    uint256 private qualifiedCredit = 12000;
    uint256 private returnedCredit = 14400;
    uint256 private commitLimit = 10;
    uint256 private purchaseLimit = 10;

    constructor() public {
        _next[GUARD] = GUARD; // header of the list.
    }

    // bonus
    function incCredit(address _user) public {
        // require(_user.purchase >= purchaseLimit && _user.commitLimit >= commitLimit);
        uint credit = user2credit[_user];
        uint16[6] memory bars = [0, 24000, 26400, 36000, 43200, 48000];
        uint8[5] memory incs = [240, 96, 16, 5, 1];
        if (credit < upperLimitCredit) {
            uint i = 0;
            uint j = 1;
            while (j < bars.length) {
                if (bars[i] <= credit && credit < bars[j]) {
                    credit += incs[i];
                    break;
                }
                i++;
                j++;
            }
            updateScore(_user, credit);
        }
    }

    // minus
    function decCredit(address _user, uint _dec) public {
        uint credit = user2credit[_user];
        _dec *= 240;
        credit -= _dec;
        // lower than 50.
        if (credit < qualifiedCredit) {
            uint8 isQual = qualifiable[_user];
            qualifiable[_user] = isQual + 1;
        }
        updateScore(_user, credit);
    }

    function isProjectable(address _user) view public returns(bool) {
        return isQualifiable(_user) && (getCredit(_user) >= 50);
    }
 
    function isQualifiable(address _user) view private returns(bool) {
        return qualifiable[_user] < 2;
    }

    function getCredit(address _user) view public returns(uint) {
        return user2credit[_user] / 240;
    }

    function updateCredit(address _user, uint newCredit) public {
        updateScore(_user, newCredit * 240);
    }

    function updateScore(address _user, uint newCredit) private {
        require(_next[_user] != address(0));
        address prev = _findPrev(_user);
        address next = _next[_user];
        if (_verifyIndex(prev, newCredit, next)) {
            user2credit[_user] = newCredit;
        } else {
            removeCredit(_user);
            addCredit(_user, newCredit);
        }
    }

    function addCredit(address _user, uint credit) public {
        require(_next[_user] == address(0));
        address index = _findIndex(credit);
        user2credit[_user] = credit;
        _next[_user] = _next[index];
        _next[index] = _user;
        listSize++;
    }

    function setCredit(address _user) public {
        addCredit(_user, initCredit);
        qualifiable[_user] = 0;
    }

    function removeCredit(address _user) public {
        require(_next[_user] != address(0));
        address prev = _findPrev(_user);
        _next[prev] = _next[_user];
        _next[_user] = address(0);
        user2credit[_user] = 0;
        listSize--;
    }

    function getTopTen() public view returns(address[] memory) {
        require(listSize > 10);
        address[] memory addressLists = new address[](10);
        address currentAddress = _next[GUARD];
        for (uint i = 0; i < 10; i++) {
            addressLists[i] = currentAddress;
            currentAddress = _next[currentAddress];
        }
        return addressLists;
    }

    function _verifyIndex(address prev, uint newValue, address next) 
        internal view returns(bool) {
        return (prev == GUARD || user2credit[prev] >= newValue)
            && (next == GUARD || newValue > user2credit[next]);
    }

    function _findIndex(uint newValue) internal view returns(address) {
        address candidateAddress = GUARD;
        while(true) {
            if (_verifyIndex(candidateAddress, newValue, _next[candidateAddress]))
                return candidateAddress;
            candidateAddress = _next[candidateAddress];
        }
    }

    function _isPrev(address user, address prev) internal view returns(bool) {
        return _next[prev] == user;
    }

    function _findPrev(address user) internal view returns(address) {
        address currentAddress = GUARD;
        while(_next[currentAddress] != GUARD) {
            if (_isPrev(user, currentAddress))
                return currentAddress;
            currentAddress = _next[currentAddress];
        }
        return address(0);
    }

}
```

