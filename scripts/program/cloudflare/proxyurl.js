addEventListener("fetch", event => {
    event.respondWith(handleRequest(event.request))
})
  
async function handleRequest(request) {
    //替换url
    let url = new URL(request.url).toString();
    let patter = /^([a-z]{4,5}:\/\/[\w|\.]*\/)/g;
    let urlmatchs = patter.exec(url);
    url = request.url.replace(urlmatchs[1],"")
    if(url == "")
        return new Response(`请传入需要代理的url`, {
        status: 500,
    });
    //get请求单独处理
    if (request.method == 'GET'){
        return fetch(url, {
        method: request.method, // *GET
        headers: request.headers
        });
    }else{
        //其他请求处理
        return fetch(url, {
        method: request.method, // *POST, PUT, DELETE, etc.
        headers: request.headers,
        body: request.body
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