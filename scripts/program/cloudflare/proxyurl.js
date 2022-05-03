addEventListener("fetch", event => {
    event.respondWith(handleRequest(event.request))
  })
  
async function handleRequest(request) {
    let baseResponse = {
        status: "",
        message: ""
    }
    //替换url
    let url = new URL(request.url).toString();
    let patter = /^([a-z]{4,5}:\/\/[\w|\.]*\/)/g;
    let urlmatchs = patter.exec(url);
    url = request.url.replace(urlmatchs[1],"")
    if(url == ""){
        baseResponse.status = 500;
        baseResponse.message = "请传入需要代理的url";
        return new Response(JSON.stringify(baseResponse), {
        status: 500,
        });
    }

    //get请求单独处理
    if (request.method == 'GET'){
        return fetch(url, {
        method: request.method, // *GET
        headers: request.headers
        }).catch(err => {
        baseResponse.status = 500;
        baseResponse.message = "url请求失败，请检查请求参数或稍后重试";
        baseResponse.error = err;
        return new Response(JSON.stringify(baseResponse), {
            status: 500,
        });
        });
    }else{
        //其他请求处理
        return fetch(url, {
        method: request.method, // *POST, PUT, DELETE, etc.
        headers: request.headers,
        body: request.body
        }).catch(err => {
        baseResponse.status = 500;
        baseResponse.message = "url请求失败，请检查请求参数或稍后重试";
        baseResponse.error = err;
        return new Response(JSON.stringify(baseResponse), {
            status: 500,
        });
        });
    }
}
function MethodNotAllowed(request) {
    return new Response(`Method ${request.method} not allowed.`, {
        status: 405,
        headers: {
        Allow: 'GET',
        },
    });
}