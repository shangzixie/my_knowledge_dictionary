# 浅谈前端录音功能和API

随着浏览器的发展，其自带操作音频的api也日趋强大。下图audio的进化史告诉我们在不同的时期，处理音频有不同的方法。这其中最复杂，也最有效的方法
便是[Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)。Web Audio API不仅可以实现音频的播放、停止等
功能，甚至可以创建、修改和分析声音。如果操作得当，我们甚至可以把浏览器当做synthesizer //TODO使用。
![](./web%20sound%20evolution.png)

## Web Audio API

在了解Web Audio API之前，先了解几个概念：
* **AudioContext**:音频上下文，基本上所有浏览器的音频操作都要在该环境内进行。 //TODO
* **Input**：音频源，也就是音频输入，可以是直接从设备输入的音频，也可以是远程获取的音频文件。
* **处理节点**：分析器和处理器，比如音调节点，音量节点，声音处理节点。
* **输出源**：指音频渲染设备，一般情况下是用户设备的扬声器，即context.destination。








参考：
https://segmentfault.com/a/1190000018809821
https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API