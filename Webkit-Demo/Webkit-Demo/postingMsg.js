/**
 * Created by luowei on 15/5/2.
 */

//发送消息
//window.webkit.messageHandlers.<name>.postMessage();


function postMyMessage() {

/*
     var message = {'message':'Hello,World!','numbers':[1,2,3]};
     window.webkit.messageHandlers.myName.postMessage(message);
*/



    var logoDiv = document.getElementById('logo');
    var logoImg = logoDiv != null ? logoDiv.firstElementChild : null;
    if (logoImg!=null && logoImg.tagName.toLowerCase() == 'img') {
        logoImg.src = "http://b.hiphotos.baidu.com/image/pic/item/00e93901213fb80edacf8d0f32d12f2eb83894c8.jpg"
        //logoImg.src = "http://tp1.sinaimg.cn/1745746500/180/39999543554/1"
        return "{'msg':'OK!'}"
    }

    return "{'msg':'-------'}"
}

//alert('aaaaa')
var message = postMyMessage()
window.webkit.messageHandlers.myName.postMessage(message);

