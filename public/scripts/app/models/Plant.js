/**
 * Plant Model
 */

define([
	'jquery',
	'underscore',
	'backbone'],
function($, _, Backbone) {
	return Backbone.Model.extend({
		urlRoot: 'index.php/api/v0/plant',

		getDisplayBoxData: function() {
			var common_name = this.get('common_names')[0].name;

			return {
				genus: this.get('genus'),
				species: this.get('species'),
				common_name: common_name
			};
		}
	});
});
