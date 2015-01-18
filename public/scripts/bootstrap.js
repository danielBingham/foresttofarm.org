require.config({
	baseUrl: 'scripts',
	paths: {
		jquery: 'library/jquery',
		backbone: 'library/backbone',
		underscore: 'library/underscore'
	}
});

requirejs(['app/main']);
