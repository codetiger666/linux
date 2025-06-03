addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  let baseResponse = {
    status: 200,
    message: ""
  }
  console.log(request.log)
  //替换url
  let url = new URL(request.url).toString();
  let patter = /^([\w]{4,5}:\/\/.*?\/).*/g;
  let urlmatchs = patter.exec(url);
  url = request.url.replace(urlmatchs[1], "")
  if (url == "") {
    baseResponse.status = 400;
    baseResponse.message = "请传入需要代理的url";
    return new Response(JSON.stringify(baseResponse), {
      status: 400,
      headers: {
        "Content-Type": "application/json; charset=utf-8"
      }
    });
  }
  url = decodeURIComponent(url);
  console.log(url)
  //处理GET请求
  if (request.method === 'GET') {
    return send(url, {
        method: request.method,
        headers: request.headers
    },urlmatchs[1])
  } else {
    return send(url, {
      method: request.method,
      headers: request.headers,
      body: request.body
  }, urlmatchs[1])
  }
}

async function send(url, config, host) {
  try {
    // 尝试发起 fetch 请求，并获取响应
    const response = await fetch(url, config)
    // 获取响应头
    const responseHeaders = response.headers
    // 检查是否是重定向（301 或 302）
    if (response.status === 301 || response.status === 302) {
      // 获取重定向url
      let location = response.headers.get('Location')
      if (location) {
        // 需要重新编码url,防止丢参数
        responseHeaders.set('Location', host + encodeURI(location))

      // 返回修改后的重定向响应
      return new Response(null, {
            status: response.status,
            headers: responseHeaders 
          }
        )
      }
    }

    if (response.headers.get('content-type')?.includes('text/html')) {
      let originalText = await response.text()
      let remoteUrl = new URL(url)
      originalText = originalText.replace(/(src|href)="(.*?)"/g, (match, p1, p2) => {
        // 处理静态资源链接
        if (p2.startsWith('/')) {
          return `${p1}="${host}${encodeURI(`${remoteUrl.origin}${p2}`)}"`
        }
        return `${p1}="${host}${encodeURI(`${p2}`)}"`
      })
      return new Response(originalText, {
        status: response.status,
        statusText: response.statusText,
        headers: {
          ...response.headers,
          'Content-Type': 'text/html;charset=UTF-8'
        }
      })
    }

    if (config.headers.get('Accept') === 'text/event-stream') {

      // 使用流处理非重定向响应
      const { readable, writable } = new TransformStream()

      // 异常处理封装在 streamResponse 内部
      streamResponse(response.body, writable)

      // 立即返回流式响应，保持流数据传递
      return new Response(readable, {
        status: response.status,
        statusText: response.statusText,
        headers: responseHeaders // 复制原始响应的头部
      });
    }
    return response
  } catch (err) {
    let baseResponse = {}
    baseResponse.status = 400;
    baseResponse.message = "url请求失败，请检查请求参数或稍后重试";
    baseResponse.error = err;
    return new Response(JSON.stringify(baseResponse), {
      status: 400,
      headers: {
        "Content-Type": "application/json; charset=utf-8"
      }
    });
  }
}

// 使用流的方式逐块处理响应数据，同时处理异常
async function streamResponse(readableStream, writableStream) {
  const reader = readableStream.getReader()
  const writer = writableStream.getWriter()
  try {
    // 持续读取流中的数据块
    while (true) {
      const { done, value } = await reader.read()
      if (done) {
        break
      }
      // 将每个块写入输出流
      await writer.write(value)
    }
    // 关闭写入流
    await writer.close()
  } catch (err) {
    // 关闭流，避免未完成的传输导致问题
    console.error("Stream processing error:", err); 
    // 建议添加错误日志
    await writer.abort(err);
  } finally {
    // 确保 reader 和 writer 被释放
    reader.releaseLock();
    writer.releaseLock();
  }
}