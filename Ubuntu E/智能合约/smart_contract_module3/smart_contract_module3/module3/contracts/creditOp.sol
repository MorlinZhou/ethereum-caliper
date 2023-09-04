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