
(function($, Drupal) {
  // Custom functions and variables can go here
  Drupal.behaviors.custom_js_libraries = {
    attach:function() {
        var _SlideshowTransitions = [
            //Fade
            { $Duration:700,$Opacity:2,$Brother:{$Duration:1000,$Opacity:2} }
        ];

        var options = {
            $FillMode: 1,                                       //[Optional] The way to fill image in slide, 0 stretch, 1 contain (keep aspect ratio and put all inside slide), 2 cover (keep aspect ratio and cover whole slide), 4 actuall size, default value is 0
            $DragOrientation: 3,                                //[Optional] Orientation to drag slide, 0 no drag, 1 horizental, 2 vertical, 3 either, default value is 1 (Note that the $DragOrientation should be the same as $PlayOrientation when $DisplayPieces is greater than 1, or parking position is not 0)
            $AutoPlay: true,                                    //[Optional] Whether to auto play, to enable slideshow, this option must be set to true, default value is false
            $AutoPlayInterval: 2000,                            //[Optional] Interval (in milliseconds) to go for next slide since the previous stopped if the slider is auto playing, default value is 3000
            $SlideshowOptions: {                                //[Optional] Options to specify and enable slideshow or not
                $Class: $JssorSlideshowRunner$,                 //[Required] Class to create instance of slideshow
                $Transitions: _SlideshowTransitions,            //[Required] An array of slideshow transitions to play slideshow
                $TransitionsOrder: 1,                           //[Optional] The way to choose transition to play slide, 1 Sequence, 0 Random
                $ShowLink: true,                                    //[Optional] Whether to bring slide link on top of the slider when slideshow is running, default value is false
                $SlideWidth : 600,
                $SlideHeight: 300
            }
        };
        //Without this, if an image slider isn't present on the page, we get an error since the plugin is loaded on every page.
        if($('#slider1_container').length){
            var jssor_slider1 = new $JssorSlider$("slider1_container", options);

            function ScaleSlider() {
            var parentWidth = $('#slider1_container').parent().width();
            if (parentWidth < 600) {
                jssor_slider1.$SetScaleWidth(parentWidth);
            }
            else
                window.setTimeout(ScaleSlider, 30);
            }
            //Scale slider after document ready
            ScaleSlider();
            if (!navigator.userAgent.match(/(iPhone|iPod|iPad|BlackBerry|IEMobile)/)) {
                //Capture window resize event
                $(window).bind('resize', ScaleSlider);
            }
        }
        
    }
  };
}(jQuery, Drupal));

