require.config({
	baseUrl: '/scripts',
	paths: {
		jquery: 'library/jquery',
		backbone: 'library/backbone',
		underscore: 'library/underscore',
		mustache: 'library/mustache',
		text: 'library/text'
	}
});

requirejs(['app/main']);
