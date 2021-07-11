$(document).ready(function(){
    function imageToDataUri(width, height,img,player) {
        // create an off-screen canvas
        var canvas = document.createElement('canvas'),
            ctx = canvas.getContext('2d');
    
        // set its dimension to target size
        canvas.width = width;
        canvas.height = height;
        var image = new Image()
        image.src = img
        image.onload = function(){
            ctx.drawImage(image, 897,450, width, height,0,0,width,height)
            data = JSON.stringify({ image: canvas.toDataURL('image/jpeg',0.8),player:player});
            $.post('http://esx_policejob/getnewphoto', data );
        }
    }
    window.addEventListener('message', function( event ) {
        if (event.data.action == 'convert') {
            imageToDataUri(126, 164,event.data.img,event.data.player)
        }
    })
})
//ctx.drawImage(image, 897,622, width, height,0,0,width,height)