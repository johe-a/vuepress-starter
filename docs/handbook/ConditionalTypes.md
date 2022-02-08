---
title: 函数式编程
author: johehuang
date: '2022-01-15'
---
- [函数式编程概念](#函数式编程概念)
  - [命令式与函数式(声明式)编程](#命令式与函数式声明式编程)
  - [函数是一等公民](#函数是一等公民)
  - [纯函数](#纯函数)
    - [纯函数的好处](#纯函数的好处)
  - [柯里化](#柯里化)
  - [compose组合函数](#compose组合函数)
- [函数式编程的好处](#函数式编程的好处)
- [函数式编程常见实践](#函数式编程常见实践)
- [提升函数式编程技巧的方法](#提升函数式编程技巧的方法)
- [参考链接](#参考链接)
# 函数式编程概念
函数式编程是一种编程范式，我们常见的编程范式有**命令式编程(Imperative Programming)、函数式编程、逻辑式编程。** `面向对象编程` 也是一种命令式编程。

`函数式编程` 会成为下一个编程的主流范式，未来的程序员或多或少都必须懂一点。

优秀的编码原则有哪些？
- DRY(don't repeat yourself)：不要重复自己
- Loose coupling high cohension：高内聚低耦合
- YAGNI(ya ain't gonna need it)： 你不会用到它的
- Principle of least surprise： 最小意外原则
- Single responsibility： 单一责任

在以命令式编程的方式编码时，我们可能会遇到以下问题：
- 可变状态(mutable state)
- 无限制的副作用(unrestricted sizde effects)
- 无原则设计(unprincipled design)

函数式编程具有以下特性：
- 声明式
- 函数是一等公民：函数可以于其他数据类型一样，处于平等地位，可以复制给其他变量，也可以作为参数传入另一个函数，或者作为函数的返回值
- Immutability(数据不可变)：一个变量被创建赋值后，就不能被再次赋值和修改
- No side-effect(没有副作用)：函数的输出只依赖于它的输入，同样的输入一定得到同样的输出，并且函数不会修改入参，也不会对外界造成影响，例如发起请求、修改全局变量等等
- 柯里化函数
- 代码组合

## 命令式与函数式(声明式)编程
- **什么是命令式编程？** 命令式编程有变量、赋值语句、表达式、控制语句。命令式编程的程序就是一个指令的序列。
- **什么是函数式编程？** 函数式编程是面向数学的抽象，将计算描述为一种表达式求值。函数式编程的程序就是一个表达式。

**函数式编程关心数据的映射，命令式编程关系解决问题的步骤**

是不是很抽象？我们可以用身边实际的例子来解释一下，假设我们要打车：  
命令式：
1. 上车
2. 告诉司机路口右转
3. 直行500米
4. 路口左转
5. ...

函数式编程(声明式)：
1. 上车
2. 告诉司机目的地
3. 到站下车

## 函数是一等公民
> 当我们说函数是一等公民的时候，我们实际上说的是它和其他对象都一样，可以像其他任何数据类型一样对待它们，把它们存在数组里、当做参数传递、赋值给变量等等。

其实这是Javascript最基本的概念了，函数作为一个引用类型，本身就能够和对象(函数本身也是对象)一样被对待，但是我们的代码中经常无视这个概念，例如：
```javascript
const hi = name => `Hi ${name}`;
const greeting = name => hi(name);

```
这里 `greeting` 被赋值的匿名包裹函数完全是多余的。为什么？ 因为 JavaScript 的函数是可调用的，例如：
```javascript
hi; // name => `Hi ${name}`的引用
hi("jonas"); // "Hi jonas"
// 所以我们可以
const greeting = hi;
greeting("times");
```

**添加一些没有实际用处的简介层实现起来很容易，但只要除了徒增代码量，提高维护和检索代码成本之外，没有任何作用**

例如以下代码：
```javascript
httpGet('/post/2', json => renderPost(json));

```
上面的代码中，传递的第二个参数是一个完全没有必要的包裹函数，如果我们需要接收的参数改变了，例如需要接收多一个 `err` 异常，那我们还需要回去把整个 **胶水** 函数给修改了：
```javascript
httpGet('/post/2', (json, err) => renderPost(json, err));

```
用 **函数是一等公民** 的形式，要做的改动会少得多：
```javascript
httpGet('/post/2', renderPost);

```
除了删除不必要的函数，正确的为参数命名也不可少。项目中常见的一种造成混淆的原因是，针对同一个概念使用不同的命名，还有通用代码的问题。  
例如，下面两个函数做的事情一致，但后一个显得更通用，可重用性也更高：
```javascript
// 只针对当前的博客
const validArticles = articles =>
  articles.filter(article => article !== null && article !== undefined),

// 对未来的项目更友好
const compact = xs => xs.filter(x => x !== null && x !== undefined);

```

## 纯函数
> 纯函数是这样一种函数，对于同样的输入，永远会得到相同的输出，而且没有任何可观察的副作用。

> 纯函数就是数学上的函数，而且是函数式编程的全部。其他的特性，都是为了让我们更好的写纯函数或者拓展纯函数的能力。

纯函数有以下特点：
- 对于同样的输入，永远得到同样的输出，意味着函数的返回结果只依赖于它的输入参数。
- 没有任何副作用，不会对外部造成任何影响。

如何辨别纯函数？
```javascript
const a = 1;
const foo = (b) => a + b;
foo(2);

```
foo函数不是一个纯函数，因为它返回的结果依赖于外部变量a，我们在不知道a的值的情况下，并不能保证foo(2)返回值是3，它的返回值是不可预料的。

```javascript
const foo= (a, b) => a + b;
foo(1, 2); //3
```
现在foo的返回结果只依赖于它的参数a和b。对于同样的入参，输出一定相同。这就满足纯函数的第一个条件，一个函数的返回结果只依赖于它的参数。

假设有以下函数:
```javascript
const a = 1
const foo = (obj, b) => {
  obj.x = 2
  return obj.x + b
}
const counter = { x: 1 }
foo(counter, 2) // => 4
counter.x // => 2
```
foo函数的执行对外部的counter产生了影响，它产生了副作用，修改了外部传进来的对象，所以它是不纯的。**如果函数修改的是内部构件的变量，然后对数据进行的修改不是副作用。**
```javascript
const foo = (b) => {
  const obj = { x: 1 };
  obj.x = 2;
  return obj.x + b;
}

```
除了修改外部的变量，一个函数在执行过程中还有很多方式可以产生副作用，例如发送Ajax请求，调用DOM API修改页面，甚至console.log也算是副作用。

### 纯函数的好处
为什么要煞费苦心的构建纯函数？ 因为纯函数非常靠谱，执行一个函数你不用担心它产生什么副作用，产生不可预料的行为。不管什么情况下，同样的入参都会输出相同的结果。如果你的应用程序大多数函数都是由纯函数组成，那么你的程序测试、调试起来会非常方便。

总的来说，纯函数有以下好处：
- 可缓存性(Cacheable)
- 可移植性/自文档化(Portable / Self-Documenting)
- 可测试性(Testable)
- 合理性(Reasonable)
- 并行代码/无竞争

**可缓存性(Cacheable)**

实现缓存纯函数结果的一种典型方式是 `memorize` 技术。
```javascript
const squareNumber = memorize(x => x*x);

squareNumber(4); // 16

squareNumber(4); // 从缓存中读取输入值为4的结果，16

```
下面是一个简单的 `memorize` 实现，尽管不太壮健：
```javascript
const memorize = (f) => {
  const cache = {};
  return () => {
    const argStr = String(arguments[0]);
    cache[argStr] = cache[argStr] || f.apply(f, arguments[0]);
    return cache[argStr];
  }
}

```
由于函数是第一等公民，所以函数当然也可以被缓存。值得注意的一点是，可以通过延迟执行的方式把不纯的函数转换为纯函数：
```javascript
const pureHttpCall = memoize((url, params) => {
  return () => $.getJSON(url, params)
});

```
这里有趣的地方在于我们并没有真正发送 http 请求——只是返回了一个函数，当调用它的时候才会发请求。这个函数之所以有资格成为纯函数，是因为它总是会根据相同的输入返回相同的输出：给定了 url 和 params 之后，它就只会返回同一个发送 http 请求的函数。

在 `React` 中，我们可以使用 `useCallback` 或者 `useMemo` 的方式分别去缓存函数和函数的执行结果。还可以使用 `React.memo`来缓存纯函数组件。

**可移植性/自文档化**

命令式编程中典型的方法和过程都深深地根植于它们所在的环境中，通过状态、依赖和作用达成。纯函数则与此相反，它与环境无关，只要我们愿意，可以在任何地方运行它。可移植性意味着把函数序列化(serializing)并通过socket发送，这也意味着代码能够在 web workers 中运行。

**可测试性**

纯函数由于只依赖入参，并且输入输出稳定可靠，所以测试起来也更容易。

**合理性**

很多人相信使用纯函数最大的好处是引用透明性（referential transparency）。如果一段代码可以替换成它执行所得的结果，而且是在不改变整个程序行为的前提下替换的，那么我们就说这段代码是引用透明的。

**并行代码**

最后一点，也是决定性的一点：我们可以并行运行任意纯函数。因为纯函数根本不需要访问共享的内存，而且根据其定义，纯函数也不会因副作用而进入竞争态（race condition）。

## 柯里化
`curry`(柯里化)：在数学和计算机科学中，柯里化是一种将使用多个参数的一个函数转换成一系列使用一个参数的函数的技术。

**柯里化是函数式编程的一种技巧。**

```javascript
function add(a,b){
    return a + b;
}

// 执行add函数，一次传入两个参数
add(1,2);//3

// 假设有一个curry函数可以做到柯里化
var addCurry = curry(add);
addCurry(1)(2); //3

```
curry函数应该怎么写？我们可以简单的写一个版本，尽管这个版本有缺陷：
```javascript
const curry = (fn, ...arguments) => {
  const length = fn.length;
  const presetArgs = [...arguments];
  return (...newArguments) => {
    const args = [...presetArgs, ...newArguments];
    if (args.length < length) {
      return curry.apply(fn, [fn, ...args]);
    } else {
      return fn.apply(fn, args);
    }
  }
}
```
我们也可以借助成熟工具库的curry函数，例如Lodash。

> 柯里化函数给我们表现出的性质是：当入参达不到目标函数的参数数量要求时，会返回一个新的判断函数，并且将之前传入的参数缓存起来。

柯里化的这种特性有什么好处呢？
1. 预设参数，延迟计算
2. 函数在拥有不同数量参数的情况下，有不同的含义，更加声明式
3. 减少中间变量

如何理解减少中间变量这一项？
```javascript
// 不使用curry
.map(x => x + 1);

// 使用curry, add(1)返回一个需要接收x的函数
.map(add(1));
```

让我们来创建一些curry函数享受下：
```javascript
import _ from 'lodash';

// 柯里化匹配函数，字符串str匹配上reg时，返回匹配的数组
const match = _.curry((reg, str) => str.match(reg));

// 柯里化替换函数，将字符串str的origin字符串替换为replacement
const replace = _.curry((origin, replacement, str) => str.replace(orgin, replacement));

// 柯里化过滤函数
const filter = _.curry((func, ary) => ary.filter(func));

// 柯里化map
const map = _.curry((func, ary) => ary.map(func));
```
我们来看下如何使用这些柯里化函数：
```javascript
match(/\s+/g, "hello world");
// [' ']

match(/\s+/g)("hello world");
// [' ']

const matchSpaces = match(/\s+/g);
// str => str.match(/\s+/g);

matchSpaces("hello world");
// [' ']

// filter是柯里化的过滤函数，需要接收过滤方法和数组
filter(matchSpaces, ["hello world", "hello"]);
// ["hello world"]

const findHasSpaces = filter(matchSpaces);
// ary => ary.filter(matchSpaces);

findHasSpaces(["hello world", "hello"]);
// ["hello world"]

const noVowels = replace(/[aeiou]/ig);
// (replacement, str) => str.replace(/[aeiout]ig/, replacement);

const censored = noVowels("*");

censored("Chocalate Rain");
// 'Ch*c*l*t* R**n'

```

> **当我们谈论纯函数的时候，我们说它们接受一个输入返回一个输出，curry函数所做的也是如此，每传递一个参数调用函数，就返回一个新函数处理剩余的参数。**

## compose组合函数
> 组合函数就像是在搭积木，我们可以随意选择两个积木(函数)， 让它们拼接(结合)，就成了一个新的积木(函数)。

组合函数的定义如下：
```javascript
const compose = (f, g) => {
  return x => f(g(x));
}
```
> `f` 和 `g` 都是函数， `x` 是在它们之间通过"管道"传输的值。

组合函数的用法如下：
```javascript
const toUpperCase = x => x.toUpperCase();
const exclaim = x => x + '!';
const shout = compose(exclaim, toUpperCase);

shout("send in the clowns");
// SEND IN THE CLOUMNS
```
shout是一个组合函数，它的功能是将传入的字符串经过大写转换后，在末尾加上感叹号。

两个函数组合之后返回了一个新函数，这是完全讲得通的。组合某种类型的两个元素就应该生成一个该类型的新元素(积木+积木=积木)。

> 在 `compose` 的定义中， `g` 优先于 `f` 执行，**因此就创建了一个从右到左的数据流**。这样做的可读性远远高于嵌套一大堆的函数调用。

如果不使用组合，`shout` 函数应该是这样的：
```javascript
const shout = x => exclaim(toUpperCase(x));
```
**让代码从右到左运行，而不是从内而外的执行。**
```javascript
const head = x => x[0];
const reverse = reduce((acc, x) => [x].concat(acc), []);
const last = compose(head, reverse);

last(['jumpkick', 'roundhouse', 'uppercut']);

```
上面的代码中，reverse 用于反转列表， head 取得列表中的第一个元素。组合后，先反转然后取到列表中的第一个元素，结果就是得到了一个取列表最后一个元素的函数。

**组合的概念来自于数学课本，所以所有的组合都满足组合律的特性**
```javascript
// 组合律
const associative = compose(f, compose(g, h)) = compose(compose(f, g), h);

```
假设我们想要取得列表中最后一个字符串进行大写，利用组合律有以下写法:
```javascript
compose(toUpperCase, compose(head, reverse));

compose(compose(toUpperCase, head), reverse);
```
因为如何为compose的调用分组并不重要，所以结果都是一致的。 这也让我们有能写一个可变的组合：
```javascript
const lastUpper = compose(toUpperCase, head, reverse);
lastUpper(['jumpkick', 'roundhouse', 'uppercut']);
//=> 'UPPERCUT'

const loudLastUpper = compose(exclaim, toUpperCase, head, reverse)

loudLastUpper(['jumpkick', 'roundhouse', 'uppercut']);
//=> 'UPPERCUT!'
```



# 函数式编程的好处
# 函数式编程常见实践
# 提升函数式编程技巧的方法
# 参考链接
- [函数式编程指北](https://llh911001.gitbooks.io/mostly-adequate-guide-chinese/content/ch2.html#%E4%B8%BA%E4%BD%95%E9%92%9F%E7%88%B1%E4%B8%80%E7%AD%89%E5%85%AC%E6%B0%91)