// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone/wikiando
//= require backbone.modelbinding
//= require backbone.validation
//= require easypaginate.min
//= require jquery.timeago
//= require geo/base
//= require handlebars

//= require_tree .

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};
