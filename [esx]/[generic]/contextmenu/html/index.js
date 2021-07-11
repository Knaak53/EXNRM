$(function () {
    var objectType = null;
    var contextElement = document.getElementById("context-menu");
    var isAdmin = false;

    function display(bool) {
        if (bool) {
            $("#container").show();
            $("#close").show();
        } else {
            $("#container").hide();
            $("#close").hide();
        }
    }
    display(false) 
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
        if (item.type === "objectData") {
            clearContextmenu();
            objectType = item.objectType;             
            isAdmin = item.admin;
            populateContextMenu(item.entityActionList);
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27 || data.which == 66) {
            document.getElementById("context-menu").classList.remove("active");
            clearObjectData();
            clearContextmenu();
            $.post('https://contextmenu/exit', JSON.stringify({}));
            return
        }
    };

    document.addEventListener("click", (e) => {
        if(!($(e.target).hasClass("sub-menu"))){
            document.getElementById("context-menu").classList.remove("active");
            $.post('https://contextmenu/action', JSON.stringify({action: e.target.id}));
            clearObjectData();
            console.log("yes: "+e.target.id)
            //console.log($("#"+e.target.id).attr("id"))
        }else{
            
        }
    })
    
    window.addEventListener("contextmenu",function(event){
        event.preventDefault();
        clearContextmenu();
        $.post('https://contextmenu/rightclick', JSON.stringify({}));
        
        console.log(event.offsetY)
        if(event.offsetY != null && event.offsetY != undefined && event.offsetX != null && event.offsetX != undefined){
            contextElement.style.top = event.offsetY - 25 + "px";
            contextElement.style.left = event.offsetX - 150 + "px";
        }
    });
    window.addEventListener("click",function(e){
        //document.getElementById("context-menu").classList.remove("active");
    });
 
    function clearObjectData(){
        objectType = null;
        doorIndex = null;
    }

    function addHr(){
        node = document.createElement("hr");
        node.classList.add('.hrclass');
        document.getElementById("context-menu").appendChild(node);
    }
    
    function populateContextMenu(entitySelfActions){
        if (entitySelfActions != undefined && entitySelfActions != null){
            if (entitySelfActions.singleButtons != undefined && entitySelfActions.singleButtons != null && entitySelfActions.singleButtons.length > 0){
                buildSingleButtons(entitySelfActions.singleButtons)
                //addHr();
            }
            if (entitySelfActions.subMenus != undefined && entitySelfActions.subMenus != null && entitySelfActions.subMenus.length > 0){
                buildSubMenus(entitySelfActions.subMenus)
            }
        }
        //addHr();
        //createMenuItem("Examinar", "examine", false);
        //createMenuItem("Cerrar", "close", false);
        contextElement.classList.add("active");
    }

    function buildSingleButtons(singleButtons){
        for(var i = 0; i < singleButtons.length; i++){
            createMenuItem(upperCaseFirstLetter(singleButtons[i].label), singleButtons[i].action, false);
        }
    }

    function buildSubMenus(subMenus){
        for(var i = 0; i < subMenus.length; i++){
            createMenuItem(subMenus[i].subLabel, subMenus[i].subName + "-menu", true, subMenus[i].subColor, subMenus[i].actions);
            //createSubMenu(subMenus[i].subName + "-sub-menu", subMenus[i].subName + "-menu");
            //createSubMenuItems(subMenus[i].actions, subMenus[i].subName + "-sub-menu", subMenus[i].subColor);
        }
    }

    function clearContextmenu(){
        var item = document.getElementById("context-menu");
        item.innerHTML = ''; //<--- Look into a CLEANER option.
    }

    function createMenuItem(name, id, isSub, color,str){
        var node;
        var textnode;
        var li;
        var a;
        var span;
        var emoteAndName;
        //node = document.createElement("div");
        node = document.createElement("li");
        span = document.createElement("span")
        console.log("name: "+name)
        if(name.indexOf("-", 0) > -1){
            emoteAndName = name.split("-")
            span.textContent = emoteAndName[0];
            textnode = document.createTextNode(emoteAndName[1]);
        } else{
            textnode = document.createTextNode(name);
        }
       
        //li = document.createElement("li");
        a = document.createElement("a");
        a.setAttribute("id", id);
        //node.classList.add("menu");
        //if(isSub){
        //    node.classList.add("sub-menu");  
        //    $("#"+submenu).click(function() {
        //        clearContextmenu()
        //        for (i = 0; i < str.length; ++i)
        //    {
        //        createMenuItem(str[i].label, str[i].action.replace(/\s/g, ""), false, false)
        //        //node = document.createElement("li");
        //        //textnode = document.createTextNode(upperCaseFirstLetter(str[i].label));
        //        //node.setAttribute("id", str[i].action.replace(/\s/g, ""));
        //        //node.classList.add("menu-item");
        //        //if(color != undefined && color != null){
        //        //    node.classList.add(color);
        //        //}else{
        //        //    node.classList.add("default");
        //        //}
        //        //node.appendChild(textnode);
        //        //document.getElementById(submenu).appendChild(node);
        //    }
        //    });
        //}        
        if(color != undefined && color != null){
            node.classList.add(color);
        }else{
            node.classList.add("default");
        }
        a.appendChild(span);
        a.appendChild(textnode);
        node.appendChild(a)
        //node.appendChild(li);
        
        document.getElementById("context-menu").appendChild(node);

        if(isSub){
            a.classList.add("sub-menu");  
            $("#"+id).click(function() {
                clearContextmenu()
                for (i = 0; i < str.length; ++i)
            {
                createMenuItem(str[i].label, str[i].action.replace(/\s/g, ""), false, false)
                //node = document.createElement("li");
                //textnode = document.createTextNode(upperCaseFirstLetter(str[i].label));
                //node.setAttribute("id", str[i].action.replace(/\s/g, ""));
                //node.classList.add("menu-item");
                //if(color != undefined && color != null){
                //    node.classList.add(color);
                //}else{
                //    node.classList.add("default");
                //}
                //node.appendChild(textnode);
                //document.getElementById(submenu).appendChild(node);
            }
            });
        }        
    }

    function createSubMenu(subMenu, parentNode){
        var node = document.createElement("div");
        node.setAttribute("id", subMenu);
        node.classList.add("inside-sub-menu");  
        document.getElementById(parentNode).appendChild(node);
    }

    function createSubMenuItems(str, submenu, color){
        console.log(JSON.stringify(str))
        var node;
        var textnode;
        $("#"+submenu).click(function() {
            clearContextmenu()
            for (i = 0; i < str.length; ++i)
        {
            createMenuItem(str[i].label, str[i].action.replace(/\s/g, ""), false, false)
            //node = document.createElement("li");
            //textnode = document.createTextNode(upperCaseFirstLetter(str[i].label));
            //node.setAttribute("id", str[i].action.replace(/\s/g, ""));
            //node.classList.add("menu-item");
            //if(color != undefined && color != null){
            //    node.classList.add(color);
            //}else{
            //    node.classList.add("default");
            //}
            //node.appendChild(textnode);
            //document.getElementById(submenu).appendChild(node);
        }
        });
        
    }
    
    function upperCaseFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    function sleep(milliseconds) {
        const date = Date.now();
        let currentDate = null;
        do {
            currentDate = Date.now();
        } while (currentDate - date < milliseconds);
    }
})