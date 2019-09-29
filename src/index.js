$(document).ready(function() {
  var mathFieldSpan = document.getElementById("math-field");
  var MQ = MathQuill.getInterface(2);
  var mathField = MQ.MathField(mathFieldSpan, {
    spaceBehavesLikeTab: true,
    handlers: {
      edit: function() {
        Opal.eval("Calculator::Parser.new(%q{"+mathField.latex()+"}).run");
      }
    }
  });
});
