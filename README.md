# **环境搭建**（一）

## **一**.**以太坊钱包** 

以太坊钱包是我们进入以太坊系统的门户。它包含了私钥，可以代表我们创建和广播交易。

MetaMask：一个浏览器扩展钱包，可在浏览器中运行。

• 打开Google Chrome浏览器并导航至： • https://chrome.google.com/webstore/category/extensions • 搜索“MetaMask”并单击狐狸的徽标。您应该看到扩展程序的详细信息页面如下

![image-20220119205955988](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220119205955988.png)

安装MetaMask后，应该在浏览器的工具栏中看到一个新图标（狐狸头）。点击它开始。系统会要求接受条款和条件，然后输入密码来创建新的以太坊钱包。

<img src="https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220119210617055.png" alt="image-20220119210617055" style="zoom: 80%;" />

设置密码后，MetaMask将生成一个钱包，并显示由12个英文单词组成的助记符（**记得备份**）。若MetaMask或计算机出现问题，导致无法打开钱包，我们可以在任何兼容的钱包中使用这些单词来恢复对资金的访问。

### 切换网络 

• Main Network（Network ID： 1）主要的、公共的，以太坊区块链。真正的ETH，真正的价值，真正的结果。 

• **Ropsten Test Network（Network ID： 3）** 以太坊公共测试区块链和网络，使用工作量证明共识（挖矿）。该网络上的 ETH 没 有任何价值。

 • Kovan Test Network（Network ID： 42） •以太坊公共测试区块链和网络，使用“Aura”协议进行权威证明 POA 共识（联合签 名）。该网络上的 ETH 没有任何价值。此测试网络仅由 Parity 支持。 

• **Rinkeby Test Network（Network ID： 4）**以太坊公共测试区块链和网络，使用“Clique”协议进行权威证明 POA 共识（联合签 名）。该网络上的 ETH 没有任何价值。 

• Localhost 8545 • 连接到与浏览器在同一台计算机上运行的节点。该节点可以是任何公共区块链（main  或 testnet）的一部分，也可以是私有 testnet。 

Ropsten和Rinkeby比较常用，着重关注。

### 获取测试以太

 钱包有了，地址有了，接下来需要做的就是为我们的钱包充值。 我们不会在主网络上这样做，因为真正的以太坊需要花钱。以太坊测试网络给了我们免费获取测试以太的途径：水龙头 （ faucet ）

**1.Ropsten**

按绿色“request 1 ether from faucet”按钮。将在页面的下半部分看到一 个交易ID。水龙头应用程序创建了一个交易付款给您，交易ID如下所示。(该网络不太稳定，需要多次尝试，更加推荐使用Rinkeby测试网络）

<img src="https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220119213458039.png" alt="image-20220119213458039" style="zoom:50%;" />

<img src="https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220119213359085.png" alt="image-20220119213359085" style="zoom: 80%;" />

在区块浏览器中查看https://ropsten.etherscan.io/

<img src="https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220119214907264.png" alt="image-20220119214907264" style="zoom:67%;" />

**2.Rinkeby**

 rinkeby地址，https://www.rinkeby.io/#faucet，该测试链不需要自己购买或者挖矿获取以太币，只需要申请就可以获取。获取方法：在推特、脸书、发布自己钱包地址的消息，并将消息的网址粘贴到上面截图的输入框中选个获取就可以，选第三个获得18.75以太/3days。

推特发文时将红框里面的地址改为测试链中自己的钱包地址

![img](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��4472062-d5c1f7c0ca8e248f.png)



![img](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��4472062-165ee679bb559ade.png)

![img](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��4472062-ac30b6fd97a39dd0.png)

在区块浏览器中查看,https://rinkeby.etherscan.io/

![image-20220113094014023](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220113094014023.png)

配置完成后跟着pdf文档《在 Remix 上构建简单的水龙头合约》动手实操一下，加深理解。

## 二、以太坊客户端安装

以太坊客户端是一个软件应用程序，它实现以太坊规范并通过p2p 网络与其他以太坊客户端进行通信。如果不同的以太坊客户端符合参考规范和标准化通信协议，则可以进行相互操作。以太坊是一个开源项目，由“黄皮书”正式规范定义。除了各种以太坊改进提案之外，此正式规范还定义了以太坊客户端的标准行为。因为以太坊有明确的正式规范，以太网客户端有了许多独立开发的软件实现，它们之间又可以彼此交互。

• go-ethereum ( Go ) 官方推荐，开发使用最多 地址：https://github.com/ethereum/go-ethereum 

以太坊**全节点** 

• 全节点是整个主链的一个副本，存储并维护链上的所有数据，并随时验证新区块的合法性。 区块链的健康和扩展弹性，取决于具有许多独立操作和地理上分散 的全节点。每个全节点都可以帮助其他新节点获取区块数据，并提供所有交易和合约的独立验证。 运行全节点将耗费巨大的成本，包括硬件资源和带宽。 • **以太坊开发不需要在实时网络（主网）上运行的全节点。我们可以使用测试网络的节点来代替，也可以用本地私链，或者使用服务商 提供的基于云的以太坊客户端；这些几乎都可以执行所有操作**

全节点的优缺点

优点 • 为以太坊网络的灵活性和抗审查性提供有力支持。 • 权威地验证所有交易。 • 可以直接与公共区块链上的任何合约交互。 • 可以离线查询区块链状态（帐户，合约等）。 • 可以直接把自己的合约部署到公共区块链中。 缺点 • 需要巨大的硬件和带宽资源，而且会不断增长。 • 第一次下载往往需要几天才能完全同步。 • 必须及时维护、升级并保持在线状态以同步区块。

公共测试网络节点的优缺点 

优点 • 一个 testnet 节点需要同步和存储更少的数据，大约10GB，具体取决 于不同的网络。 • 一个 testnet 节点一般可以在几个小时内完全同步。 • 部署合约或进行交易只需要发送测试以太，可以从“水龙头”免费获 得。 • 测试网络是公共区块链，有许多其他用户和合约运行（区别于私链）。

 缺点 • 测试网络上使用测试以太，它没有价值。因此，无法测试交易对手的安全性，因为没有任何利害关系。 • 测试网络上的测试无法涵盖所有的真实主网特性。例如，交易费用虽然是发送交易所必需的，但由于gas免费，因此 testnet 上往往不会考虑。而且一般来说，测试网络不会像主网那样经常拥堵.

本地私链的优缺点 

优点 • 磁盘上几乎没有数据，也不同步别的数据，是一个完全“干净”的 环境。 • 无需获取测试以太，你可以任意分配以太，也可以随时自己挖矿获 得。 • 没有其他用户，也没有其他合约，没有任何外部干扰。 

缺点 • 没有其他用户意味与公链的行为不同。发送的交易并不存在空间或 交易顺序的竞争。 • 除自己之外没有矿工意味着挖矿更容易预测，因此无法测试公链上 发生的某些情况。 • 没有其他合约，意味着你必须部署要测试的所有内容，包括所有的包括所有的依赖项和合约库。 

Geth ( Go-Ethereum ) • Geth是由以太坊基金会积极开发的 Go 语言实现，因此被认为是以 太坊客户端的“官方”实现。 • 通常，每个基于以太坊的区块链都有自己的Geth实现。 • 以太坊的 Geth github 仓库链接： https://github.com/ethereum/go-ethereum

### Go环境配置

运行以太坊之前首先安装ubantu系统(推荐16.04或者18.04版本，ubantu我这里用的VM虚拟机安装18.04版本，比较方便，一些基本的比如换源之类的我就不赘述了，网上有很多教程，大家自行操作安装)。

然后需要go环境配置，go版本不能低于1.9，我用的是最新的1.17.6，下载网址https://studygolang.com/dl或者https://go.dev/dl/。具体配置方法可参考这篇博客[(46条消息) ubuntu18.04安装Go语言_lucyLee的博客-CSDN博客_ubuntu安装go](https://blog.csdn.net/u014454538/article/details/88649963)，纠正这个博客里的一个错误，编写hello.go时第一行应该是package main而不是package hello,否则会报错go run: cannot run non-main package。

检验一下是否安装成功

![image-20220119225927866](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220119225927866.png)

### go-ethereum安装

安装 Geth 有很多种方式，这里主要就 Linux 环境给出两种：系统包管理器（apt-get）安装和源码安 装。更加推荐大家用源码安装，在整个过程中可以看到 Geth 各组件的构建步骤。 安装go-ethereum之前确保已经安装gcc

一、apt-get 

$ sudo apt-get install software-properties-common 

$ sudo add-apt-repository -y ppa:ethereum/ethereum

 $ sudo apt-get update 

$ sudo apt-get install ethereum 

卸载同时删除配置文件

apt-get purge ethereum

二、源码安装 

1. 克隆 github 仓库 我们的第一步是克隆 git 仓库，以获取源代码的副本。 

   $ git clonehttps://github.com/ethereum/go-ethereum.git

2. 从源码构建 Geth，切换到下载源代码的目录并使用 make 命令： 

   $ cd go-ethereum 

   $ make geth

**以太坊安装常见失败场景**

1.GitHub克隆时报错：
fatal: unable to access ‘https://github.com/ethereum/go-ethereum.git/’: gnutls_handshake() failed: Error in the pull function.

git config --global --unset http.proxy

再查询，已经没有了代理，然后再push,成功了！

2.go: github.com/Azure/azure-pipeline-go@v0.2.2: Get https://proxy.golang.org/github.com/%21azure/azure-pipeline-go/@v/v0.2.2.mod: dial tcp 172.217.24.17:443: connect: connection refused make: *** [geth] Error 1

可执行该命令解决

go env -w GOPROXY=https://goproxy.cn

3.没有安装gcc![image-20220120170257967](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220120170257967.png)



<img src="https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220118200325444.png" alt="image-20220118200325444" style="zoom: 80%;" />

编译成功！

<img src="https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220118205237928.png" alt="image-20220118205237928" style="zoom:80%;" />

这是我的geth版本信息，供大家参考

### 搭建自己的私有链

因为公共网络的区块数量太多，同步耗时太长，我们为了方便快速了解 Geth，可以试着用它来搭一个 只属于自己的私链，首先，我们需要创建网络的创世状态，这写在一个小小的 JSON 文件里（例如，我们 将其命名为 genesis.json）视频里的jsin文件格式太旧了，大家可以参考我的文件格式或者去以太坊的github上下载。

![image-20220213220041065](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220213220041065.png)

要创建一条以它作为创世块的区块链，我们可以使用下面的命令：

 geth --datadir path/to/custom/data/folder init genesis.json 在当前目录下运行 geth，就会启动这条私链，注意要将 networked 设置为与创世块配置里的 chainId 一致。

 geth --datadir path/to/custom/data/folder --networkid 15 我们可以看到节点正常启动：

初始化私有链

![image-20220126172201997](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220126172201997.png)

启动私有链

![image-20220126172553678](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220126172553678.png)

启动节点同步 

安装好了 Geth，现在我们可以尝试运行一下它。执行下面的命令，geth 就会开始同步区块，并存储在当前目录下。这里的 --syncmode fast 参数表示我们会以“快速”模式同步区块。在这种模式下，我 们只会下载每个区块头和区块体，但不会执行验证所有的交易，直到所有区块同步完毕再去获取一个系统 当前的状态。这样就节省了很多交易验证的时间。

 $ geth –datadir . --syncmode fast 通常，在同步以太坊区块链时，客户端会一开始就下载并验证每个块和每个交易，也就是说从创世区块开始。 毫无疑问，如果我们不加 --syncmode fast 参数，同步将花费很长时间并且具有很高的资源要 求（它将需要更多的 RAM，如果你没有快速存储，则需要很长时间）。 有些文章会把这个参数写成 --fast，这是以前快速同步模式的参数写法，现在已经被 –syncmode fast 取代。 如果我们想同步测试网络的区块，可以用下面的命令： $ geth --testnet --datadir . --syncmode fast --testnet 这个参数会告诉 geth 启动并连接到最新的测试网络，也就是 Ropsten。测试网络的区块 和交易数量会明显少于主网，所以会更快一点。但即使是用快速模式同步测试网络，也会需要几个小时的时间。

Geth Console 是一个交互式的 JavaScript 执行环境，里面内置了一些用来操作以太坊的 JavaScript  对象，我们可以直接调用这些对象来获取区块链上的相关信息。这些对象主要包括： eth：主要包含对区块链进行访问和交互相关的方法； net：主要包含查看 p2p 网络状态的方法； admin：主要包含与管理节点相关的方法； miner：主要包含挖矿相关的一些方法； personal：包含账户管理的方法； txpool：包含查看交易内存池的方法； web3：包含以上所有对象，还包含一些通用方法。 常用命令有： personal.newAccount()：创建账户； personal.unlockAccount()：解锁账户； eth.accounts：列出系统中的账户； eth.getBalance()：查看账户余额，返回值的单位是 Wei； eth.blockNumber：列出当前区块高度； eth.getTransaction()：获取交易信息； eth.getBlock()：获取区块信息； **miner.start**()：开始挖矿； miner.stop()：停止挖矿； web3.fromWei()：Wei 换算成以太币； web3.toWei()：以太币换算成 Wei； txpool.status：交易池中的状态；

![image-20220126212502172](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220126212502172.png)

geth控制台查看账户余额，账户之间转账交易、挖矿、查看区块高度等基本操作这里不再赘述，出现的常见错误可参考https://blog.csdn.net/m0_52739647/article/details/121896246?spm=1001.2014.3001.5502

连接到本地localhost8545端口查看交易结果，注意教程里的版本过旧，--rpc已修改为--http

![image-20220213220316957](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220213220316957.png)

![image-20220213220610177](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220213220610177.png)



建议大家有时间跟着资料以及视频教程，熟悉一下geth控制台的基本命令。



### 以太坊账户类型 

**外部账户** (Externally owned account, EOA ) 

又叫用户/普通账户，背后是人来控制，比如钱包 

• 有对应的以太币余额 

• 可发送交易（转币或触发合约代码）

• 由用户私钥控制 

• 没有关联代码

**合约账户** (Contract accounts)

又叫不普通账户、内部账户

• 有对应的以太币余额 

• 有关联代码 

• 由代码控制

 • 可通过交易或来自其它合约的调用消息来触发代码执行

 • 执行代码时可以操作自己的存储空间，也可以调用其它合约

![image-20220120105040716](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220120105040716.png)

用户通过私钥来控制普通账户（如Metamask），普通账户发起交易来调用合约里的代码，合约是由开发者直接部署到区块链上，以这种方式达到人和区块链上账户交互的目的。

### 以太坊交易（Transaction）

签名的数据包，由EOA发送到另一个账户 

• 消息的接收方地址 

• 发送方**签名** 

• 金额（VALUE） 

• 数据（DATA，可选）

 • START GAS  

• GAS PRICE

### 消息（Message）

 -- 合约可以向其它合约发送“消息” ，消息存在于合约之间

-- 消息是不会被序列化的虚拟对象，只存在于以太坊执行环境 （EVM）中 ，不一定能被查到

-- 可以看作函数调用 

• 消息**发送方** 

• 消息接收方

 • 金额（VALUE）

 • 数据（DATA，可选）

• START GAS

### 合约（Contract）

 • 可以读/写自己的内部存储（32字节key-value的 数据库） 

• 可向其他合约发送消息，依次触发执行 

• 一旦合约运行结束，并且由它发送的消息触发的所有子执行（sub-execution）结束，EVM就会中止运行，直到下次交易被唤醒

合约应用一 

• 维护一个数据存储（账本），存放对其他合约或外部世界有用的内容 （不可更改的账本）

• 最典型的例子是模拟货币的合约（代币）

合约应用二 

• 通过合约实现一种具有更复杂的访问策略的普通账户（EOA）， 这被称为“转发合同”：只有在满足某些条件时才会将传入的消息 重新发送到某个所需的目的地址；例如，一个人可以拥有一份转 发合约，该合约会等待直到给定三个私钥中的两个确认之后，再 重新发送特定消息

• 钱包合约是这类应用中很好的例子

合约应用三 

• 管理多个用户之间的持续合同或关系 

• 这方面的例子包括金融合同，以及某些特定的托管合同或某种保险

### 交易的本质

 • 交易是由外部拥有的账户发起的签名消息，由以太坊网络传输，并被序列化后记录在以太坊区块链上。

 • 交易是唯一可以触发状态更改或导致合约在EVM中执行的事物。

 • 以太坊是一个全局单例状态机，交易是唯一可以改变其状态的东西。 

 • 合约不是自己运行的，以太坊也不会“在后台”运行。以太坊上的一切变化都始于交易

**交易数据结构** 

交易是包含以下数据的序列化二进制消息：

• nonce：由发起人EOA发出的序列号，用于防止交易消息重播。 

• gas price：交易发起人愿意支付的gas单价（wei）。

• start gas：交易发起人愿意支付的最大gas量。 

• to：目的以太坊地址。 

• value：要发送到目的地的以太数量。 

• data：可变长度二进制数据负载（payload）。 

• v,r,s：发起人EOA的ECDSA签名的三个组成部分。 

• 交易消息的结构使用递归长度前缀（RLP）编码方案进行序列化，该方案 专为在以太坊中准确和字节完美的数据序列化而创建。

**交易中的nonce** 

• 黄皮书定义： 一个标量值，等于从这个地址发送的交易数，或者对于关联 code的帐户来说，是这个帐户创建合约的数量。 

• nonce不会明确存储为区块链中帐户状态的一部分。相反，它是通过计算发 送地址的已确认交易的数量来动态计算的。 

• nonce值还用于防止错误计算账户余额。nonce强制来自任何地址的交易按顺序处理，没有间隔，无论节点接收它们的顺序如何。 

• 使用nonce确保所有节点计算相同的余额和正确的序列交易，等同于用于防止比特币“双重支付”（“重放攻击”）的机制。但是，由于以太坊跟踪账户余额并且不单独跟踪 UTXO ，因此只有在错误地计算账户余额时才会 发生“双重支付”。nonce机制可以防止这种情况发生。

**交易中的gas**

• **当由于交易或消息触发** EVM 运行时，每个指令都会在网络的每个节点上 执行。这具有成本：对于每个执行的操作，都存在固定的成本，我们把这个成本用一定量的 gas 表示。 

• gas 是交易发起人需要为 EVM 上的每项操作支付的成本名称。发起交易时， 我们需要从执行代码的矿工那里用以太币购买 gas 。 

• gas 与消耗的系统资源对应，这是具有自然成本的。因此在设计上 gas 和 ether 有意地解耦，消耗的 gas 数量代表了对资源的占用，而对应的交易费 用则还跟 gas 对以太的单价有关。这两者是由自由市场调节的：gas 的价 格实际上是由矿工决定的，他们可以拒绝处理 gas 价格低于最低限额的交 易。我们不需要专门购买 gas ，只需将以太币添加到帐户即可，客户端在发送交易时会自动用以太币购买汽油。而以太币本身的价格通常由于市场力量而波动。

gas的计算 

• 发起交易时的 gas limit 并不是要支付的 gas 数量，而只是给定了一个 消耗 gas 的上限，相当于“押金”

• 实际支付的 gas 数量是执行过程中消耗的 gas （gasUsed），gas  limit 中剩余的部分会返回给发送人

 • 最终支付的 gas 费用是 gasUsed 对应的以太币费用，单价由设定的 gasPrice 而定 

• 最终支付费用 **totalCost = gasPrice * gasUsed** 

• **totalCost 会作为交易手续费（Tx fee）支付给矿工**

**交易的接收者（to）** 

• 交易接收者在to字段中指定，是一个20字节的以太坊地址。地址可以 是EOA或合约地址。

• 以太坊没有进一步的验证，任何20字节的值都被认为是有效的。如果 20字节值对应于没有相应私钥的地址，或不存在的合约，则该交易仍然有效。以太坊无法知道地址是否是从公钥正确派生的。 

• 如果将交易发送到无效地址，将销毁发送的以太，使其永远无法访问。 

• 验证接收人地址是否有效的工作，应该在用户界面一层完成

**交易的 value 和 data** 

• 交易的主要“有效负载”包含在两个字段中：value 和 data。交易可 以同时有 value 和 data，仅有 value，仅有 data，或者既没有 value  也没有 data。所有四种组合都有效。 

• 仅有 value 的交易就是一笔以太的付款 

• 仅有 data 的交易一般是合约调用 

• 进行合约调用的同时，我们除了传输 data， 还可以发送以太，从而交 易中同时包含 data 和 value 

• 没有 value 也没有 data 的交易，只是在浪费 gas，但它是有效

**向 EOA 或合约传递 data** 

• 当交易包含数据有效负载时，它很可能是发送到合约地址的，但它同样可以发送给 EOA 

• 如果发送 data 给 EOA，数据负载（data payload） 的解释取决于钱包 

• 如果发送数据负载给合约地址，EVM 会解释为函数调用，从 payload 里解 码出函数名称和参数，调用该函数并传入参数 

• 发送给合约的数据有效负载是32字节的十六进制序列化编码： ——函数选择器：函数原型的 Keccak256 哈希的前4个字节。这允许 EVM 明确地识别将要调用的函数。 ——函数参数：根据 EVM 定义的各种基本类型的规则进行编码

**特殊交易：创建（部署）合约**

• 有一中特殊的交易，具有数据负载且没有 value，那就是一个创建新合约的交易。 

• 合约创建交易被发送到特殊目的地地址，即零地址0x0。该地址既不 代表 EOA 也不代表合约。它永远不会花费以太或发起交易，它仅用 作目的地，具有特殊含义“创建合约”。 

• 虽然零地址仅用于合约注册，但它有时会收到来自各种地址的付款。 这种情况要么是偶然误操作，导致失去以太；要么是故意销毁以太。 

• 合约注册交易不应包含以太值，只包含合约的已编译字节码的数据有 效负载。此交易的唯一效果是注册合约

## 以太坊虚拟机（EVM） 

• 以太坊虚拟机 EVM 是智能合约的运行环境 

• 作为区块验证协议的一部分，参与网络的每个节点都会运行 EVM。他们会检查正在验证的块中列出的交易，并运行由 EVM中的交易触发的代码 

• EVM不仅是沙盒封装的，而且是完全隔离的，也就是说在 EVM 中运行的代码是无法访问网络、文件系统和其他进程的， 甚至智能合约之间的访问也是受限的 

• 合约以字节码的格式（EVM bytecode）存在于区块链上 • 合约通常以高级语言（solidity）编写，通过EVM编译器编译 为字节码，最终通过客户端上载部署到区块链网络中

**EVM和账户** 

• 以太坊中有两类账户： 外部账户和合约账户，它们共用 EVM中同一个地址空间 

• 无论帐户是否存储代码，这两类账户对 EVM 来说处理方 式是完全一样的 

• 每个账户在EVM中都有一个键值对形式的持久化存储。其 中 key 和 value 的长度都是256位，称之为存储空间 （storage）

**EVM和交易** 

• 交易可以看作是从一个帐户发送到另一个帐户的消息，它可以包含二进制数据（payload）和以太币 

• 如果目标账户含有代码，此代码会在EVM中执行，并以 payload 作为入参，这就是合约的调用 

• 如果目标账户是零账户（账户地址为 0 )，此交易就将创建 一个新合约 ，这个用来创建合约的交易的 payload 会被 转换为 EVM 字节码并执行，执行的输出作为合约代码永久存储

**EVM和gas** 

• 合约被交易触发调用时，指令会在全网的每个节点上执行：这需要消 耗算力成本；每一个指令的执行都有特定的消耗，gas 就用来量化表 示这个成本消耗 • 一经创建，每笔交易都按照一定数量的 gas 预付一笔费用，目的是限 制执行交易所需要的工作量和为交易支付手续费 • EVM 执行交易时，gas 将按特定规则逐渐耗尽 • gas price 是交易发送者设置的一个值，作为发送者预付手续费的单 价。如果交易执行后还有剩余， gas 会原路返还 • 无论执行到什么位置，一旦 gas 被耗尽（比如降为负值），将会触发 一个 out-of-gas 异常。当前调用帧（call frame）所做的所有状态修改 都将被回滚

**EVM数据存储** 

Storage 

• 每个账户都有一块持久化的存储空间，称为 storage，这是一个将256位字映射到256位字的 key-value 存储区，可以理解为合约的数据库 • 永久储存在区块链中，由于会永久保存合约状态变量，所以读写的 gas 开销也最大 

Memory（内存）

• 每一次消息调用，合约会临时获取一块干净的内存空间 • 生命周期仅为整个方法执行期间，函数调用后回收，因为仅保存临时变量，故读写 gas 开销较 小 

Stack（栈） 

• EVM 不是基于寄存器的，而是基于栈的，因此所有的计算都在一个被称为栈（stack）的区域 执行 • 存放部分局部值类型变量，几乎免费使用的内存，但有数量限

**EVM指令集** 

• 所有的指令都是针对"256位的字（word）"这个基本的数 据类型来进行操作 

• 具备常用的算术、位、逻辑和比较操作，也可以做到有条 件和无条件跳转 

• 合约可以访问当前区块的相关属性，比如它的块高度和时间戳

**消息调用（ Message Calls ）** 

• 合约可以通过消息调用的方式来调用其它合约或者发送以太币到非合约账户 

• 合约可以决定在其内部的消息调用中，对于剩余的 gas ， 应发送和保留多少

• 如果在内部消息调用时发生了 out-of-gas 异常（或其他任 何异常），这将由一个被压入栈顶的错误值所指明；此时 只有与该内部消息调用一起发送的 gas 会被消耗掉

**合约的创建和自毁** 

• 通过一个特殊的消息调用 create calls，合约可以创建其 他合约（不是简单的调用零地址） • 合约代码从区块链上移除的唯一方式是合约在合约地址上 的执行自毁操作 selfdestruct ；合约账户上剩余的以太币 会发送给指定的目标，然后其存储和代码从状态中被移除

### Solidity是什么 

 Solidity 是一门面向合约的、为实现智能合约而创建的高级编程语言。这门语言受到了 C++，Python 和 Javascript 语言的 影响，设计的目的是能在以太坊虚拟机（EVM）上运行。 • Solidity 是静态类型语言，支持继承、库和复杂的用户定义类 型等特性。 • 内含的类型除了常见编程语言中的标准类型，还包括 address  等以太坊独有的类型，Solidity 源码文件通常以 .sol 作为扩展 名 • 目前尝试 Solidity 编程的最好的方式是使用 Remix。Remix 是一个基于 Web 浏览器的 IDE，它可以让你编写 Solidity 智能合约，然后部署并运行该智能合约。

Solidity语言特性 Solidity的语法接近于JavaScript，是一种面向对象的语言。但作为一 种真正意义上运行在网络上的去中心合约，它又有很多的不同： • 以太坊底层基于**帐户**，而不是 UTXO，所以增加了一个特殊的 **address** 的数据类型用于**定位用户和合约账户**。 • 语言内嵌框架支持支付。提供了 **payable 等关键字**，可以在**语言层面直接支持支付**。 • 使用区块链进行数据存储。数据的每一个状态都可以**永久存储**，所以在使用时需要确定变量使用内存，还是区块链存储。 • 运行环境是在去中心化的网络上，所以需要强调合约或函数执行的调用的方式。 • 不同的异常机制。一旦出现异常，所有的执行都将会被回撤，这主要是为了保证合约执行的原子性，以避免中间状态出现的数据不一致。

Solidity源码和智能合约 

• Solidity 源代码要成为可以运行在以太坊上的智能合约需要经历如下的步骤：

1. 用 Solidity 编写的智能合约源代码需要先使用编译器编译为字节码 （Bytecode），编译过程中会同时产生智能合约的二进制接口规范 （Application Binary Interface，简称为ABI）；
2. 通过**交易**（Transaction）的方式将**字节码部署到以太坊网络**，每次成功部署都会产生一个**新的智能合约账户**； 
3. 使用 Javascript 编写的 DApp 通常通过 **web3.js + ABI**去调用智能合约中的函数来实现数据的读取和修改。

Solidity编译器 Remix 

• Remix 是一个基于 Web 浏览器的 Solidity IDE；可在线使用而无需安装任何东西 

• http://remix.ethereum.org

 solcjs 

• solc 是 Solidity 源码库的构建目标之一，它是 Solidity 的命令行编译器 

• 使用 npm 可以便捷地安装 Solidity 编译器 solcjs 

• npm install -g solc（使用npm之前需配置**node**，网上教程很多，这里不再赘述）

![image-20220123092933222](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220123092933222.png)

Solidity源文件布局 pragma （版本杂注） 

• 源文件可以被版本 杂注pragma所注解，表明要求的编译器版本 

• 例如：pragma solidity ^0.4.0; 

• 源文件将既不允许低于 0.4.0 版本的编译器编译， 也不允许高于（包含） 0.5.0 版本的编译器编译（第二个条件因 使用 ^ 被添加）import（导入其它源文件） 

• Solidity 所支持的导入语句import，语法同 JavaScript（从 ES6 起）非常类似

Solidity函数声明和类型函数的值类型有两类：- 内部（internal）函数和 外部（external） 函数 

• 内部函数只能在当前合约内被调用（更具体来说，在当前代码块内，包括内 部库函数和继承的函数中），因为它们不能在当前合约上下文的外部被执行。 调用一个内部函数是通过跳转到它的入口标签来实现的，就像在当前合约的内部调用一个函数。

 • 外部函数由一个地址和一个函数签名组成，可以通过外部函数调用传递或者返回 

• 调用内部函数：直接使用名字 f 

• 调用外部函数：this.f（当前合约），a.f（外部合约）

Solidity函数可见性 函数的可见性可以指定为 external，public ，internal 或者 private； **对于状态变量，不能设置为 external ，默认是 internal。** 

• external ：外部函数作为合约接口的一部分，意味着我们可以从其他合 约和交易中调用。 一个外部函数 f不能从内部调用（即 f 不起作用， 但 this.f() 可以）。 当收到大量数据的时候，外部函数有时候会更有效 率。

 • public ：public 函数是合约接口的一部分，可以在内部或通过消息调用。 对于 public 状态变量， 会自动生成一个 getter 函数。 • internal ：这些函数和状态变量只能是内部访问（即从当前合约内部或 从它派生的合约访问），不使用 this 调用。 • private ：private 函数和状态变量仅在当前定义它们的合约中使用，并 且不能被派生合约使用。

• pure：纯函数，不允许修改或访问状态 

• view：不允许修改状态 

• payable：允许从消息调用中接收以太币Ether 。 

• constant：与view相同，一般只修饰状态变量，不允许赋值 （除初始化以外）

以下情况被认为是修改状态： • 修改状态变量。 • 产生事件。 • 创建其它合约。 • 使用 selfdestruct。 • 通过调用发送以太币。 • 调用任何没有标记为 view 或者 pure 的函数。 • 使用低级调用。 • 使用包含特定操作码的内联汇编。

以下被认为是从状态中进行读取： • 读取状态变量。 • 访问 this.balance 或者 .balance。 • 访问 block，tx， msg 中任意成员 （除 msg.sig 和 msg.data 之外）。 • 调用任何未标记为 pure 的函数。 • 使用包含某些操作码的内联汇编。

## web3.js

• Web3 JavaScript app API 

• web3.js 是一个JavaScript API库。要使DApp在以太坊上运行， 我们可以使用web3.js库提供的web3对象 

• web3.js 通过RPC调用与本地节点通信，它可以用于任何暴露 了RPC层的以太坊节点 

• web3 包含 eth 对象 - web3.eth（专门与以太坊区块链交互） 和 shh 对象 - web3.shh（用于与 Whisper 交互)

web3 模块加载 

• 首先需要将 web3 模块安装在项目中： npm install web3@0.20.1 --save-

• 然后创建一个 web3 实例，设置一个“provider” 

• 为了保证我们的 MetaMask 设置好的 provider 不被覆盖掉，在引入 web3 之前 我们一般要做当前环境检查（以v0.20.1为例）： if (typeof web3 !== 'undefined') {  web3 = new Web3(web3.currentProvider);  } else { web3 = new Web3(new Web3.providers .HttpProvider("http://localhost:8545"));  }

### **简单的投票合约**问题总结

接下来我们要开始真正做一个DApp，尽管它这是很简单的一个投票应用，但会包含完整的工作流程和交互页面。构建这个应用的主要步骤如下： 1. 我们首先安装一个叫做 ganache 的模拟区块链，能够让我们的程序在开发环境中
运行。

2. 写一个合约并部署到 ganache 上。

3. 然后我们会通过命令行和网页与 ganache 进行交互。
    我们与区块链进行通信的方式是通过 RPC（Remote Procedure Call）。web3js 是一个 JavaScript 库，它抽象出了所有的 RPC 调用，以便于你可以通过 JavaScript 与区块链进行交互。另一个好处是，web3js 能够让你使用你最喜欢的 JavaScript 框架构建非常棒的 web 应用。

4. 开发准备-Linux 下面是基于Linux的安装指南。这要求我们预先安装 nodejs 和 npm，再用npm安装 ganache-cli、web3和solc，就可以继续项目的下一步了。

   mkdir simple_voting_dapp cd simple_voting_dapp 

​       npm init 

​       npm install ganache-cli web3@0.20.1 solc 如果安装成功，运行命令./node_modules/.bin/ganache-cli，应该能够看到下图所示的输出。

  ![image-20220313152450060](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220313152450060.png)

  若碰到以下问题

![image-20220313152211943](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220313152211943.png)

解决办法： export NODE_OPTIONS=--openssl-legacy-provider，node17.0以上的版本不支持这样做，我理解是它不支持直接运行ganache-cli。

Solidity合约 

我们会写一个叫做 Voting 的合约，这个合约有以下内容： 

一个构造函数，用来初始化一些候选者。 

一个用来投票的方法（对投票数加 1）

一个返回候选者所获得的总票数的方法 当你把合约部署到区块链的时候，就会调用构造函数，并只调用一次。与 web 世界里每次部署代码都会覆盖旧代码不同，在区块链上部署的合约是不可改变的，也就是说，如果你更新合约并再次部署，旧的合约仍然会在区块链上存在，并且数据仍在。新的部署将会创建合约的一个新的实例。

代码和解释

pragma solidity ^0.4.22;

 contract Voting {

 mapping (bytes32 => uint8) public votesReceived; 

bytes32[] public candidateList;

 constructor(bytes32[] candidateNames) public {

 candidateList = candidateNames; 

} 

function totalVotesFor(bytes32 candidate) view public returns (uint8){ 

require(validCandidate(candidate)); return votesReceived[candidate]; 

} 

function voteForCandidate(bytes32 candidate) public { require(validCandidate(candidate)); votesReceived[candidate] += 1; 

}

 function validCandidate(bytes32 candidate) view public returns (bool) { 

for(uint i = 0; i < candidateList.length; i++) { 

if (candidateList[i] == candidate) { 

return true;

}

} 

return false; 

} 

}

Line 1. 我们必须指定代码将会哪个版本的编译器进行编译 Line 3. mapping 相当于一个关联数组或者是字典，是一个键值对。mapping votesReceived 的键是候选者的名字，类型为 bytes32。mapping 的值是一个未赋值的整型，存储的是投票数。 Line 4. 在很多编程语言中（例如java、python中的字典<HashTable继承自字典>），仅仅通过 votesReceived.keys 就可以获取所有的候选者姓名。但是，但是在 solidity 中没有这样的方法，所以我们必须单独管理一个候选者数组 candidateList。 Line 14. 注意到 votesReceived[key] 有一个默认值 0，所以你不需要将其初始化为 0，直接加1 即可。 你也会注意到每个函数有个可见性说明符（visibility specifier）（比如本例中的 public）。这意味着，函数可以从合约外调用。如果你不想要其他任何人调用这个函数，你可以把它设置为私有（private）函数。如果你不指定可见性，编译器会抛出一个警告。最近 solidity 编译器进行了一些改进，如果用户忘记了对私有函数进行标记导致了外部可以调用私有函数，编译器会捕获这个问题。 你也会在一些函数上看到一个修饰符 view。它通常用来告诉编译器函数是只读的（也就是说，调用该函数，区块链状态并不会更新）。

接下来，我们将会使用上一节安装的 solc 库来编译代码。如果你还记得的话，之前我们提到过 web3js 是一个库，它能够让你通过 RPC 与区块链进行交互。我们将会在 node 控制台里用这个库部署合约，并与区块链进行交互。

**操作之前掌握一下solc版本切换**

https://blog.csdn.net/k1nh00/article/details/123112828

solc版本必须为0.4.26不然会报错,建议大家跟着视频走一遍，不要直接复制简单投票文档中的代码。

编译的字节码信息：

![image-20220319101553136](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220319101553136.png)

![image-20220319103124352](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220319103124352.png)

提交交易结果:

![image-20220319110703749](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220319110703749.png)

## ![image-20220319151119664](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220319151119664.png)

## 用truffle 构建简单投票DApp常见问题

rpc命令过期https://www.cnblogs.com/blockchain-scholar/p/14508935.html

![image-20220412105539642](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220412105539642.png)

安装truffle时，出现无法下载错误

![image-20220412220911731](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220412220911731.png)

修改hosts文件，https://blog.csdn.net/CHYabc123456hh/article/details/107736640

修改完后即可成功下载

![image-20220412221146040](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220412221146040.png)

truffle自带solc与solidity版本不兼容问题可以参考https://blog.csdn.net/liangyihuai/article/details/103715791，

修改truffle-config.js中的对应solc版本即可成功编译

![image-20220413160358462](https://zsx--1-1300230040.cos.ap-nanjing.myqcloud.com/G:\ͼ��image-20220413160358462.png)

