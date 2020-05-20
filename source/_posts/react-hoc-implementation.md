---
title: 谈谈 React HOC 的两种实现
date: 2018-09-18 14:43:00
tags: react
---

<code>React HOC</code>  — Higher Order Component ，也即 React 的高阶组件，它通常用一个函数来实现，这个函数接受一个 Component 并输出另一个 Component ，类似于 Java 的代理模式，用组合的方式（不一定）去实现一些对象的装饰器或拦截器。

（别人的）一句话总结就是

> A Higher Order Component is just a React Component that wraps another one.

看到这里，你至少要知道它是一个**函数**，这是因为它代表的是一种模式，而不是具体的 Component 。

所以 HOC 的作用大概有以下几点：

- 代码复用（显然）和逻辑抽象
- 对 state 和 props 进行抽象和操作
- **Render 劫持**
- 对 WrappedComponent 进行细化，比如添加生命周期

以下会通过对 HOC 两种实现的讨论来深化对 HOC 作用的认识。
<!-- more -->


##  Props Proxy

Props Proxy 即 属性代理，这种实现方法本质上是“组合”，可能是我们第一时间会想到的实现方式，它通常的实现框架是这样的：

```javascript
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    render() {
      return <WrappedComponent {...this.props}/>
    }
  }
}
```

这样我们可以提前拦截到 parent component 传给它的 props ，所以我们也就能提前对 props 进行一些操作了，比如在 render 函数里面添加对 props 的处理。

我们还可以通过 ref 来获取 WrappedComponent 的实例，但 ref 需要经过一次渲染过程才能计算出来，所以我们需要在 HOC 的 render 函数中返回 WrappedComponent ，让 React 进行 Reconciliation ，之后才能通过 ref 得到 WrappedComponent 的实例。

比如下面的例子：

```javascript
function refsHOC(WrappedComponent) {
  return class RefsHOC extends React.Component {
    proc(wrappedComponentInstance) {
      wrappedComponentInstance.method()
    }
    render() {
      const props = Object.assign({}, this.props, {ref: this.proc.bind(this)})
      return <WrappedComponent {...props}/>
    }
  }
}
```

当 WrappedComponent 被渲染后，ref 上的回调函数 proc 就会执行，此时就有了这个 WrappedComponent 的实例的引用。这个的使用场景应该比较少，比如我们需要获取 WrappedComponent 里面的一些 state 来打印日志。但会有更好的方法来实现类似的功能，用 ref 的往往是不太建议的方式。

还可以通过 Props Proxy 来抽象 state ，比如我们要让一个 <code><input /\></code> 成为 Controlled 的组件，我们可以在 HOC 中添加一些 state ，让它通过 props 去控制这个 <code><input /\></code> 。

```javascript
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    constructor(props) {
      super(props)
      this.state = {
        name: ''
      }
      this.onNameChange = this.onNameChange.bind(this)
    }
      
    onNameChange(event) {
      this.setState({
        name: event.target.value
      })
    }
      
    render() {
      const newProps = {
        value: this.state.name,
        onChange: this.onNameChange
      }
      return <WrappedComponent {...this.props} {...newProps}/>
    }
  }
}

@ppHOC
class Example extends React.Component {
  render() {
    return <input name="name" {...this.props.name}/>
  }
}
```

最后一个功能就是最容易理解的了，也就是把 WrappedComponent 包起来变成一个新的组件，比如我们可以添加一些 style 和 container 。



## Inheritance Inversion

Inheritance Inversion 即 反向继承，嗯，是 HOC 去继承 WrappedComponent（此时 WrappedCompoent 应该叫别的名字比较合适）。这样我们获得了这个组件之后，能够**从内部**对它进行装饰和修改，先看看它的实现框架：

```javascript
function iiHOC(WrappedComponent) {
  return class Enhancer extends WrappedComponent {
    render() {
      return super.render()
    }
  }
}
```

是不是觉得很 Amazing >\_< 

首先我们能想到的是通过这种方式我们可以对 WrappedComponent 的 state 进行操作，比如添加新的 state ，但通常不建议使用高阶组件来读取或添加 state ，主要还是考虑到对原有 state 的破坏。

我们也可以操作 WrappedComponent 的生命周期，比如添加一个 componentDidUpdate 。

接下来是重头戏，我们可以实现**渲染劫持**，正因为我们是从内部去操纵 WrappedComponent ，所以我们可以重写 render 函数，这样我们可以在 render 函数内部去实现条件渲染，添加拦截器，甚至去修改原本的 render 方式，比如这样：

```javascript
function iiHOC(WrappedComponent) {
  return class Enhancer extends WrappedComponent {
    render() {
      const elementsTree = super.render()
      let newProps = {};
      if (elementsTree && elementsTree.type === 'input') {
        newProps = {value: 'may the force be with you'}
      }
      const props = Object.assign({}, elementsTree.props, newProps)
      const newElementsTree = React.cloneElement(elementsTree, props, elementsTree.props.children)
      return newElementsTree
    }
  }
}
```



## Conclusion

由此可以看出，Props Proxy 是从“组合”的角度出发，这样有利于从外部去操作这个 WrappedComponent ，可以操作的对象是 props ，或者在 WrappedComponent 外面加一些拦截器，控制器等等；而 Inheritance Inversion 则是从“继承”的角度出发，是从内部去操作这个 WrappedComponent ，也就是可以操作组件内部的 state ，生命周期，render函数等等。



## Reference

[React Higher Order Components in depth](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e)