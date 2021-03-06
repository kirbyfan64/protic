import 'package:test/test.dart';
import 'utils.dart';

void main() {
  test('macro definitions work', () {
    expect('<+ macro="expand">abc</+>', compilesTo(''));
    expect('<+ macro>abc</+>', compilesWithErrors(['macro name cannot be empty']));
  });

  test('macro expansions work', () {
    expect('<+ macro="expand">expand</+><+@ expand>', compilesTo('expand'));
    expect('<+@ expand>', compilesWithErrors(['undefined macro expand']));
    expect('<+@>',
           compilesWithErrors(['macro expansion requires a macro name to expand']));
    expect('<+@ name="value">',
           compilesWithErrors(['macro name should not have a value']));
    expect(r'<+ macro="expand"><+ value="var: $@var"></+><+@ expand var="1">',
           compilesTo('var: 1'));
  });

  test('macro slots work', () {
    expect('<+ macro="expand" slot><+ slot></+><+@ expand>slot contents</+@>',
           compilesTo('slot contents'));
    expect('<+ macro="expand" slot></+><+@ expand>',
           compilesWithErrors(['macro requires a slot, but none was given']));
  });

  test('required macros are available in the including file', () {
    var fileProvider = new MockFileProvider({
      'file.html': '<+ macro="expand">expanded!</+>'
                   '<+ macro="expand-slot" slot><p>slot: <+ slot></p></+>',
    });

    expect('<+ require="file.html"><+@ expand>',
           compilesTo('expanded!', fileProvider: fileProvider));
    expect('<+ require="file.html"><+@ expand-slot>contents</+@>',
           compilesTo('<p>slot: contents</p>', fileProvider: fileProvider));
  });
}
