<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html> <!--<![endif]-->
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv = "X-UA-Compatible" content = "IE=edge,chrome=1" />
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <title>发财致富之路</title>
    <link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
    <link rel="stylesheet" href="{{ asset('css/font-awesome.min.css') }}" />
    <script type="text/javascript">
    	const hostUrl = '{{ env("APP_URL") }}';
        @if (isset($signPackage))
            const wxConfig = {
                appId: '{{ $signPackage['appId'] }}',
                timestamp: '{{ $signPackage['timestamp'] }}',
                nonceStr: '{{ $signPackage['nonceStr'] }}',
                signature: '{{ $signPackage['signature'] }}',
            };
        @endif
    </script>
</head>
<body>
<link rel="stylesheet" href="{{ asset('css/style.css') }}" />
<div id="app">
    <app></app>
</div>

<script src="{{ asset('js/app.js') }}?v={{ time() }}"></script>
</body>
</html>
