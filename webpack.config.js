module.exports = {
	module: {
		rules: [
			{
				test: /\.imba$/,
				loader: 'imba/loader',
			},
			{
				test:/\.(s*)css$/,
				use: [
					"style-loader", // creates style nodes from JS strings
					"css-loader", // translates CSS into CommonJS
					"sass-loader" // compiles Sass to CSS
				]
			}
		]
	},
	resolve: {
		extensions: [".imba",".js",".json"]
	},
	entry: "./src/client.imba",
	output: {  path: __dirname + '/dist', filename: "client.js" }
}