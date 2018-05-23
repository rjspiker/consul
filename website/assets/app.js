const cssStandards = require('spike-css-standards')
const jsStandards = require('spike-js-standards')
const preactPreset = require('babel-preset-preact')
const extendRule = require('postcss-extend-rule')
const objectFit = require('postcss-object-fit-images')
const webpack = require('webpack')
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer')

console.log(`Building assets for environment *${process.env.NODE_ENV}*`)

const config = {
  ignore: [
    'yarn.lock',
    '**/_*',
    'package-lock.json',
    'js/components/*/*.css',
    'js/components/readme.md',
    'reshape.js'
  ],
  entry: {
    'js/main': './js/index.js',
    'js/commons': ['preact']
  },
  postcss: cssStandards({ appendPlugins: [extendRule(), objectFit()] }),
  babel: jsStandards({ appendPresets: [preactPreset] }),
  vendor: 'js/vendor/**',
  server: { open: false },
  plugins: [
    new webpack.optimize.CommonsChunkPlugin({
      names: ['js/commons', 'js/manifest'],
      minChunks: Infinity
    }),
    new BundleAnalyzerPlugin({
      analyzerMode: 'static',
      openAnalyzer: false
    }),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
    }),
    new webpack.ExtendedAPIPlugin()
  ]
}

module.exports = config
