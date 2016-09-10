/**
 * AbstractViewSpec
 *
 * A spec to ensure that Abstact View and AbstractParentView behave as
 * advertised.
 */
define([
    'jquery',
    'app/views/abstract/AbstractView',
    'app/views/abstract/AbstractParentView'],
function($, AbstractView, AbstractParentView) {
   

    describe('views/abstract', function() {
        var TestChildView = null;
        var TestParentView = null;

        beforeAll(function() {
            TestChildView = AbstractView.extend({
                parse_called: 0,
                update_called: 0, 
                parse: function() {
                    this.parse_called++;
                    return $.parseHTML('<p>Child</p>');
                },
                update: function() {
                    this.update_called++;
                    return AbstractView.prototype.update.call(this);
                }

            });

            TestParentView = AbstractParentView.extend({
                parse_called: 0,
                update_called: 0,
                parse: function() {
                    this.parse_called++;
                    return $.parseHTML('<div></div>');
                },
                update: function() {
                    this.update_called++;
                    return AbstractParentView.prototype.update.call(this);
                }
            });

        }); 
                
        describe('AbstractView', function() {

            it(' should call ``create()`` on initialization', function() {
                var test_view = new TestChildView();

                expect(test_view.is_created).toBe(true);
            });

            it(' should call ``parse()`` from ``create()``', function() {
                var test_view = new TestChildView();

                expect(test_view.parse_called).toEqual(1);
                expect(test_view.$el.html()).toEqual('Child');
                expect(test_view.$el[0].outerHTML).toEqual('<p>Child</p>');
            });

            it(' should not be attached to the DOM on initialization', function() {
                var test_view = new TestChildView();

                expect(test_view.is_attached_to_DOM).toBe(false);

                var in_dom = $.contains(document, test_view.$el[0]);
                expect(in_dom).toBe(false);
            });
        });

        describe('AbstractView.render()', function() {
            var test_view = null;

            beforeAll(function() {
                test_view = new TestChildView();
                test_view.render();
            });
            
            it(' should call ``update()``', function() {
                expect(test_view.update_called).toEqual(1);
            }); 

            it(' should not call ``parse()``', function() {
               expect(test_view.parse_called).toEqual(1); 
            });
        });

        describe('AbstractParentView', function() {
            
            it(' should correctly append child view to parent view', function() {
                var test_parent = new TestParentView();
                var test_child = new TestChildView();

                test_parent.appendSubview(test_child);

                expect(test_child.is_attached_to_DOM).toBe(false);
                expect(test_parent.subviews).toEqual([test_child]);
                expect(test_parent.$el.html()).toEqual('<p>Child</p>');
                expect(test_parent.$el[0].outerHTML).toEqual('<div><p>Child</p></div>');
            }); 

            it(' should propagate DOM attachment', function() {
                var test_parent = new TestParentView();
                var test_child = new TestChildView();

                test_parent.appendSubview(test_child);

                expect(test_child.is_attached_to_DOM).toBe(false);
                expect(test_parent.subviews).toEqual([test_child]);

                test_parent.markAttachedToDOM();

                expect(test_parent.is_attached_to_DOM).toBe(true);
                expect(test_child.is_attached_to_DOM).toBe(true);
            });

            it(' should correctly append multiple child views to parent view', function() {
            
                var test_parent = new TestParentView();
                var test_child = new TestChildView();
                var test_child2 = new TestChildView();

                test_parent.appendSubview(test_child);
                test_parent.appendSubview(test_child2);

                expect(test_child.is_attached_to_DOM).toBe(false);
                expect(test_child2.is_attached_to_DOM).toBe(false);

                expect(test_parent.subviews).toEqual([test_child, test_child2]);

                expect(test_parent.$el.html()).toEqual('<p>Child</p><p>Child</p>');
                expect(test_parent.$el[0].outerHTML).toEqual('<div><p>Child</p><p>Child</p></div>');
            });

        });

        describe('AbstractParentView.render()', function() {
            var test_parent = null;

            var test_child = null;
            var test_child2 = null;

            beforeAll(function() {
                test_parent = new TestParentView();
                test_child = new TestChildView();
                test_child2 = new TestChildView();

                test_parent.appendSubview(test_child);
                test_parent.appendSubview(test_child2);

                test_parent.render();
            }); 

            it(' should propagate render to child views', function() {
                expect(test_parent.update_called).toEqual(1);
                expect(test_child.update_called).toEqual(1);
                expect(test_child2.update_called).toEqual(1);
            });

            it(' should propagate ``update()``, not ``create()``', function() {
                expect(test_parent.parse_called).toEqual(1);
                expect(test_child.parse_called).toEqual(1);
                expect(test_child2.parse_called).toEqual(1);
            });
        
        });
    });
});
