String getHtmlContent({
  required String content,
  required String title,
  required String dateText,
  required String formattedDate,
  required String authorText,
  required String author,
  required String category,
}) =>
    '''
<html>
    <head>
        <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width, viewport-fit=cover" />
        <style>
            body {
                width: 90%;
                overflow-x: hidden;
                margin-left: auto;
                margin-right: auto;
                display: block;
                margin-top: 10px;
                margin-bottom: 10px;
            }
            img {
                width: 100% !important;
                margin-left: auto;
                margin-right: auto;
                display: block;
                margin-top: 20px;
                margin-bottom: 20px;
            }
            p {
                font-size: 24px;
            }
            span {
                font-size: 16px !important;
                line-height: 1.6 !important;
            }
            data-fbcssmodules="css:fb.css.base css:fb.css.dialog css:fb.css.iframewidget css:fb.css.customer_chat_plugin_iframe" > .fb_hidden {
                position: absolute;
                top: -10000px;
                z-index: 10001;
            }
            .fb_reposition {
                overflow: hidden;
                position: relative;
            }
            .fb_invisible {
                display: none;
            }
            .fb_reset {
                background: none;
                border: 0;
                border-spacing: 0;
                color: #000;
                cursor: auto;
                direction: ltr;
                font-family: "lucida grande", tahoma, verdana, arial, sans-serif;
                font-size: 11px;
                font-style: normal;
                font-variant: normal;
                font-weight: normal;
                letter-spacing: normal;
                line-height: 1;
                margin: 0;
                overflow: visible;
                padding: 0;
                text-align: left;
                text-decoration: none;
                text-indent: 0;
                text-shadow: none;
                text-transform: none;
                visibility: visible;
                white-space: normal;
                word-spacing: normal;
            }
            .fb_reset > div {
                overflow: hidden;
            }
            @keyframes fb_transform {
                from {
                    opacity: 0;
                    transform: scale(0.95);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }
            .fb_animate {
                animation: fb_transform 0.3s forwards;
            }
            .fb_dialog {
                background: rgba(82, 82, 82, 0.7);
                position: absolute;
                top: -10000px;
                z-index: 10001;
            }
            .fb_dialog_advanced {
                border-radius: 8px;
                padding: 10px;
            }
            .fb_dialog_content {
                background: #fff;
                color: #373737;
            }
            .fb_dialog_close_icon {
                background: url(https://static.xx.fbcdn.net/rsrc.php/v3/yq/r/IE9JII6Z1Ys.png) no-repeat scroll 0 0 transparent;
                cursor: pointer;
                display: block;
                height: 15px;
                position: absolute;
                right: 18px;
                top: 17px;
                width: 15px;
            }
            .fb_dialog_mobile .fb_dialog_close_icon {
                left: 5px;
                right: auto;
                top: 5px;
            }
            .fb_dialog_padding {
                background-color: transparent;
                position: absolute;
                width: 1px;
                z-index: -1;
            }
            .fb_dialog_close_icon:hover {
                background: url(https://static.xx.fbcdn.net/rsrc.php/v3/yq/r/IE9JII6Z1Ys.png) no-repeat scroll 0 -15px transparent;
            }
            .fb_dialog_close_icon:active {
                background: url(https://static.xx.fbcdn.net/rsrc.php/v3/yq/r/IE9JII6Z1Ys.png) no-repeat scroll 0 -30px transparent;
            }
            .fb_dialog_iframe {
                line-height: 0;
            }
            .fb_dialog_content .dialog_title {
                background: #6d84b4;
                border: 1px solid #365899;
                color: #fff;
                font-size: 14px;
                font-weight: bold;
                margin: 0;
            }
            .fb_dialog_content .dialog_title > span {
                background: url(https://static.xx.fbcdn.net/rsrc.php/v3/yd/r/Cou7n-nqK52.gif) no-repeat 5px 50%;
                float: left;
                padding: 5px 0 7px 26px;
            }
            body.fb_hidden {
                height: 100%;
                left: 0;
                margin: 0;
                overflow: visible;
                position: absolute;
                top: -10000px;
                transform: none;
                width: 100%;
            }
            .fb_dialog.fb_dialog_mobile.loading {
                background: url(https://static.xx.fbcdn.net/rsrc.php/v3/ya/r/3rhSv5V8j3o.gif) white no-repeat 50% 50%;
                min-height: 100%;
                min-width: 100%;
                overflow: hidden;
                position: absolute;
                top: 0;
                z-index: 10001;
            }
            .fb_dialog.fb_dialog_mobile.loading.centered {
                background: none;
                height: auto;
                min-height: initial;
                min-width: initial;
                width: auto;
            }
            .fb_dialog.fb_dialog_mobile.loading.centered #fb_dialog_loader_spinner {
                width: 100%;
            }
            .fb_dialog.fb_dialog_mobile.loading.centered .fb_dialog_content {
                background: none;
            }
            .loading.centered #fb_dialog_loader_close {
                clear: both;
                color: #fff;
                display: block;
                font-size: 18px;
                padding-top: 20px;
            }
            #fb-root #fb_dialog_ipad_overlay {
                background: rgba(0, 0, 0, 0.4);
                bottom: 0;
                left: 0;
                min-height: 100%;
                position: absolute;
                right: 0;
                top: 0;
                width: 100%;
                z-index: 10000;
            }
            #fb-root #fb_dialog_ipad_overlay.hidden {
                display: none;
            }
            .fb_dialog.fb_dialog_mobile.loading iframe {
                visibility: hidden;
            }
            .fb_dialog_mobile .fb_dialog_iframe {
                position: sticky;
                top: 0;
            }
            .fb_dialog_content .dialog_header {
                background: linear-gradient(from(#738aba), to(#2c4987));
                border-bottom: 1px solid;
                border-color: #043b87;
                box-shadow: white 0 1px 1px -1px inset;
                color: #fff;
                font: bold 14px Helvetica, sans-serif;
                text-overflow: ellipsis;
                text-shadow: rgba(0, 30, 84, 0.296875) 0 -1px 0;
                vertical-align: middle;
                white-space: nowrap;
            }
            .fb_dialog_content .dialog_header table {
                height: 43px;
                width: 100%;
            }
            .fb_dialog_content .dialog_header td.header_left {
                font-size: 12px;
                padding-left: 5px;
                vertical-align: middle;
                width: 60px;
            }
            .fb_dialog_content .dialog_header td.header_right {
                font-size: 12px;
                padding-right: 5px;
                vertical-align: middle;
                width: 60px;
            }
            .fb_dialog_content .touchable_button {
                background: linear-gradient(from(#4267b2), to(#2a4887));
                background-clip: padding-box;
                border: 1px solid #29487d;
                border-radius: 3px;
                display: inline-block;
                line-height: 18px;
                margin-top: 3px;
                max-width: 85px;
                padding: 4px 12px;
                position: relative;
            }
            .fb_dialog_content .dialog_header .touchable_button input {
                background: none;
                border: none;
                color: #fff;
                font: bold 12px Helvetica, sans-serif;
                margin: 2px -12px;
                padding: 2px 6px 3px 6px;
                text-shadow: rgba(0, 30, 84, 0.296875) 0 -1px 0;
            }
            .fb_dialog_content .dialog_header .header_center {
                color: #fff;
                font-size: 16px;
                font-weight: bold;
                line-height: 18px;
                text-align: center;
                vertical-align: middle;
            }
            .fb_dialog_content .dialog_content {
                background: url(https://static.xx.fbcdn.net/rsrc.php/v3/y9/r/jKEcVPZFk-2.gif) no-repeat 50% 50%;
                border: 1px solid #4a4a4a;
                border-bottom: 0;
                border-top: 0;
                height: 150px;
            }
            .fb_dialog_content .dialog_footer {
                background: #f5f6f7;
                border: 1px solid #4a4a4a;
                border-top-color: #ccc;
                height: 40px;
            }
            #fb_dialog_loader_close {
                float: left;
            }
            .fb_dialog.fb_dialog_mobile .fb_dialog_close_icon {
                visibility: hidden;
            }
            #fb_dialog_loader_spinner {
                animation: rotateSpinner 1.2s linear infinite;
                background-color: transparent;
                background-image: url(https://static.xx.fbcdn.net/rsrc.php/v3/yD/r/t-wz8gw1xG1.png);
                background-position: 50% 50%;
                background-repeat: no-repeat;
                height: 24px;
                width: 24px;
            }
            @keyframes rotateSpinner {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
            .fb_iframe_widget {
                display: inline-block;
                position: relative;
            }
            .fb_iframe_widget span {
                display: inline-block;
                position: relative;
                text-align: justify;
            }
            .fb_iframe_widget iframe {
                position: absolute;
            }
            .fb_iframe_widget_fluid_desktop,
            .fb_iframe_widget_fluid_desktop span,
            .fb_iframe_widget_fluid_desktop iframe {
                max-width: 100%;
            }
            .fb_iframe_widget_fluid_desktop iframe {
                min-width: 220px;
                position: relative;
            }
            .fb_iframe_widget_lift {
                z-index: 1;
            }
            .fb_iframe_widget_fluid {
                display: inline;
            }
            .fb_iframe_widget_fluid span {
                width: 100%;
            }
            .fb_mpn_mobile_landing_page_slide_out {
                animation-duration: 200ms;
                animation-name: fb_mpn_landing_page_slide_out;
                transition-timing-function: ease-in;
            }
            .fb_mpn_mobile_landing_page_slide_out_from_left {
                animation-duration: 200ms;
                animation-name: fb_mpn_landing_page_slide_out_from_left;
                transition-timing-function: ease-in;
            }
            .fb_mpn_mobile_landing_page_slide_up {
                animation-duration: 500ms;
                animation-name: fb_mpn_landing_page_slide_up;
                transition-timing-function: ease-in;
            }
            .fb_mpn_mobile_bounce_in {
                animation-duration: 300ms;
                animation-name: fb_mpn_bounce_in;
                transition-timing-function: ease-in;
            }
            .fb_mpn_mobile_bounce_out {
                animation-duration: 300ms;
                animation-name: fb_mpn_bounce_out;
                transition-timing-function: ease-in;
            }
            .fb_mpn_mobile_bounce_out_v2 {
                animation-duration: 300ms;
                animation-name: fb_mpn_fade_out;
                transition-timing-function: ease-in;
            }
            .fb_customer_chat_bounce_in_v2 {
                animation-duration: 300ms;
                animation-name: fb_bounce_in_v2;
                transition-timing-function: ease-in;
            }
            .fb_customer_chat_bounce_in_from_left {
                animation-duration: 300ms;
                animation-name: fb_bounce_in_from_left;
                transition-timing-function: ease-in;
            }
            .fb_customer_chat_bounce_out_v2 {
                animation-duration: 300ms;
                animation-name: fb_bounce_out_v2;
                transition-timing-function: ease-in;
            }
            .fb_customer_chat_bounce_out_from_left {
                animation-duration: 300ms;
                animation-name: fb_bounce_out_from_left;
                transition-timing-function: ease-in;
            }
            .fb_invisible_flow {
                display: inherit;
                height: 0;
                overflow-x: hidden;
                width: 0;
            }
            @keyframes fb_mpn_landing_page_slide_out {
                0% {
                    margin: 0 12px;
                    width: 100% - 24px;
                }
                60% {
                    border-radius: 18px;
                }
                100% {
                    border-radius: 50%;
                    margin: 0 24px;
                    width: 60px;
                }
            }
            @keyframes fb_mpn_landing_page_slide_out_from_left {
                0% {
                    left: 12px;
                    width: 100% - 24px;
                }
                60% {
                    border-radius: 18px;
                }
                100% {
                    border-radius: 50%;
                    left: 12px;
                    width: 60px;
                }
            }
            @keyframes fb_mpn_landing_page_slide_up {
                0% {
                    bottom: 0;
                    opacity: 0;
                }
                100% {
                    bottom: 24px;
                    opacity: 1;
                }
            }
            @keyframes fb_mpn_bounce_in {
                0% {
                    opacity: 0.5;
                    top: 100%;
                }
                100% {
                    opacity: 1;
                    top: 0;
                }
            }
            @keyframes fb_mpn_fade_out {
                0% {
                    bottom: 30px;
                    opacity: 1;
                }
                100% {
                    bottom: 0;
                    opacity: 0;
                }
            }
            @keyframes fb_mpn_bounce_out {
                0% {
                    opacity: 1;
                    top: 0;
                }
                100% {
                    opacity: 0.5;
                    top: 100%;
                }
            }
            @keyframes fb_bounce_in_v2 {
                0% {
                    opacity: 0;
                    transform: scale(0, 0);
                    transform-origin: bottom right;
                }
                50% {
                    transform: scale(1.03, 1.03);
                    transform-origin: bottom right;
                }
                100% {
                    opacity: 1;
                    transform: scale(1, 1);
                    transform-origin: bottom right;
                }
            }
            @keyframes fb_bounce_in_from_left {
                0% {
                    opacity: 0;
                    transform: scale(0, 0);
                    transform-origin: bottom left;
                }
                50% {
                    transform: scale(1.03, 1.03);
                    transform-origin: bottom left;
                }
                100% {
                    opacity: 1;
                    transform: scale(1, 1);
                    transform-origin: bottom left;
                }
            }
            @keyframes fb_bounce_out_v2 {
                0% {
                    opacity: 1;
                    transform: scale(1, 1);
                    transform-origin: bottom right;
                }
                100% {
                    opacity: 0;
                    transform: scale(0, 0);
                    transform-origin: bottom right;
                }
            }
            @keyframes fb_bounce_out_from_left {
                0% {
                    opacity: 1;
                    transform: scale(1, 1);
                    transform-origin: bottom left;
                }
                100% {
                    opacity: 0;
                    transform: scale(0, 0);
                    transform-origin: bottom left;
                }
            }
            @keyframes slideInFromBottom {
                0% {
                    opacity: 0.1;
                    transform: translateY(100%);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            @keyframes slideInFromBottomDelay {
                0% {
                    opacity: 0;
                    transform: translateY(100%);
                }
                97% {
                    opacity: 0;
                    transform: translateY(100%);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .flex-container {
                display: flex;
                flex-direction: row;
                flex-wrap: wrap;
                justify-content: space-between;
                align-items: flex-start;
                align-content: normal;
            }
            .flex-items:nth-child(1) {
                display: block;
                flex-grow: 0;
                flex-shrink: 1;
                flex-basis: auto;
                align-self: auto;
                order: 0;
            }
            .flex-items:nth-child(2) {
                display: block;
                flex-grow: 0;
                flex-shrink: 1;
                flex-basis: auto;
                align-self: auto;
                order: 0;
            }
            .dot {
                height: 8px;
                width: 8px;
                background-color: #9b0d84;
                border-radius: 50%;
                display: inline-block;
                margin-right: 10px;
            }
            .category {
                color: black;
                font-weight: bold;
                font-size: 8px;
            }
            .flex-items {
                color: #a72d6f;
            }
        </style>
    </head>
    <body>
        <script>
            window.onload = function () {
                var docHeight = document.documentElement.scrollHeight;
                var viewportHeight = window.innerHeight;

                if (docHeight > viewportHeight) {
                    window.FLUTTER_CHANNEL.postMessage("scrollable");
                } else {
                    window.FLUTTER_CHANNEL.postMessage("not scrollable");
                }
            };
        </script>
        <div>
            <span class="dot"></span>
            <span>$category</span>
        </div>
        <div style="font-weight: 700; margin-top: 10px; margin-bottom: 10px; font-size: 20px;">
            <h2>$title</h2>
        </div>
        <div class="flex-container">
            <div class="flex-items"><b>$authorText</b></div>
            <div class="flex-items"><b>$dateText</b></div>
        </div>
        <div class="flex-container">
            <div class="flex-items">$author</div>
            <div class="flex-items">$formattedDate</div>
        </div>

        <div>$content</div>
        <script>
            window.onscroll = function (ev) {
                if (window.innerHeight + window.scrollY >= document.body.offsetHeight) {
                    window.FLUTTER_CHANNEL.postMessage("end of scroll");
                }
            };
        </script>
    </body>
</html>

''';
