var express = require 'express'
var server = express()

server.use(express.static('./dist'))

server.get(/.*/) do |req,res|
	var html = <html>
		<head>
			<title> "Imba Gags"
			<meta charset="utf-8">
		<body>
			<script src="/client.js">
	
	return res.send html.toString

var port = process:env.PORT or 8080

var server = server.listen(port) do
	console.log 'server is running on port ' + port

# ----------- Server-Side Rendering ---------------

# import {Site} from './core/Site'

# const express = require 'express'
# let server = express()

# server.use(express.static('./dist'))

# server.get(/.*/) do |req,res|
# 	# need to supply the url of the request
# 	# by setting router-url on the root element
# 	const node = <html router-url=req:path>
# 		<head>
# 			<title> "Imba-Gags"
# 			<meta charset="utf-8">
# 			<link rel="stylesheet" href="/dist/index.css" media="screen">
# 		<body>
# 			<Site>
# 			<script src='/client.js'>
	
# 	node.router.onReady do
# 		res.send node.toString

# const port = process:env.PORT or 8080
# const server = server.listen(port) do
# 	console.log 'server is running on port ' + port
