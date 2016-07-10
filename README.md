#baicaio
<figure class="half">
<img src="http://7xjcm6.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B47%E6%9C%8810%E6%97%A5%20%E4%B8%8A%E5%8D%889.59.52.png?imageView/2/w/200">
    <img src="http://7xjcm6.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B47%E6%9C%8810%E6%97%A5%20%E4%B8%8A%E5%8D%8810.00.36.png?imageView/2/w/200">
</figure>
>白菜哦，是一款比价购物推荐类APP，类似于什么值得买。
个人swift练手项目，用了两周的业余时间，进行开发。[半年前做的，其中引用了很多OC的三方库，并且代码很乱，大家请勿模仿]

# 项目实现
1. 所有数据，均是通过request请求[白菜哦](http//:www.baicaio.com)网站，来获得
2. 数据返回后，通过[hpple](https://github.com/topfunky/hpple)进行html解析，并转化为我们需要的model对象
3. 不同的功能，只是模拟相应的网站请求操作，来完成

# 框架接口
主要是用MVCS结构
```
M：瘦Model，主要是构造方法
V：负责View的配置+数据显示
C：Controller，主要负责调用Service里面的业务方法，获取数据，然后将数据赋予View，并组织相关逻辑
S：业务逻辑方法，该模块会调用API+Model+DB层，进行数据获取，存储，Parse。
```

## License

This code is distributed under the terms and conditions of the MIT license.

```
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```






