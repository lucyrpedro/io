// JavaScript Document

    window.onload = function() {
        var anchors = document.getElementsByTagName('div');
        for(var i = 0; i < anchors.length; i++) {
            var syntax = anchors[i];
            if(syntax.className == "nocopy") {
                syntax.oncopy = function() {
                    
					return false;
                }
				syntax.oncut = function() {
					
					return false;
				}
				syntax.onpaste = function () {
					
					return false;
				}
            }
        }
    }
