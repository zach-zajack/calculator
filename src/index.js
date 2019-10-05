var MQ;
var mathFieldContainer;
var curAnsSpan;
var curExprSpan;
var answerFields = [];
var exprFields = [];
var exprFieldIds = [];

$(document).ready(function() {
  MQ = MathQuill.getInterface(2);
  mathFieldContainer = document.getElementById("math-fields");
  createMathField();
});

function createMathField() {
  mathFieldContainer.insertAdjacentHTML("beforeend",
    "<div class='equation-field'>" +
      "<span class='expr-field'></span><span class='answer-field'></span>" +
    "</div>"
  );
  var answerSpans = $(".answer-field");
  var exprSpans = $(".expr-field");
  answerFields.push(MQ.StaticMath(answerSpans[answerSpans.length-1]));
  var exprField = MQ.MathField(exprSpans[exprSpans.length-1], {
    spaceBehavesLikeTab: true,
    leftRightIntoCmdGoes: "up",
    restrictMismatchedBrackets: true,
    supSubsRequireOperand: true,
    autoSubscriptNumerals: true,
    autoCommands: "pi sqrt nthroot",
    autoOperatorNames: "ln log sin cos tan",
    handlers: {
      edit: function(exprField) {
        var answerField = answerFields[getExprFieldId(exprField)];
        if(answerField == null) { return; }
        try {
          answerField.latex(
            Opal.eval("Calculator::Parser.new(%q{"+exprField.latex()+"}).run")
          );
        } catch {
          answerField.latex("");
        }
      },
      enter: function(exprField) {
        if(exprField.latex() != "") { createMathField(); }
      },
      upOutOf: function(exprField) {
        selectMathField(getExprFieldId(exprField)-1);
      },
      downOutOf: function(exprField) {
        selectMathField(getExprFieldId(exprField)+1);
      },
      deleteOutOf: function(dir, exprField) {
        var id = getExprFieldId(exprField);
        if(id > 0 && dir < 0 && exprField.latex() == "") {
          $(".equation-field")[id].remove();
          exprFields.splice(id);
          answerFields.splice(id);
          exprFieldIds.splice(id);
          selectMathField(id-1);
        }
      }
    }
  });
  exprFields.push(exprField);
  exprFieldIds.push(exprField.id);
  selectMathField(getExprFieldId(exprField));
}

function getExprFieldId(exprField) {
  return exprFieldIds.indexOf(exprField.id);
}

function selectMathField(id) {
  return $($(".expr-field")[id]).mousedown().mouseup();
}
