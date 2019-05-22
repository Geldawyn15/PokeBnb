const PI_TWO = Math.PI * 2;
const TO_DEG = 180 / Math.PI;
const TO_RAD = Math.PI / 180;

const $container = $('#container');
const $sliceContainer = $('#slide-container');

let nextPanelPosition = 0;
let panelIndex = 0;
let state = 'forward';
let start = 0;
let end = 0;
let barSize = 0;
let per = 0;

const $next = $('.next');
const $prev = $('.prev');

const panels = [];

const colors = [
    '#A8EF85',
    '#66D0ED',
    '#F6869A'
  ];

const tween = new TWEEN.Tween( {x: 0} )
        .to( { x: 25 }, 500 )
        .easing( TWEEN.Easing.Exponential.InOut )
        .onUpdate( function () {

          $sliceContainer.css('transform', `translate(-${this.x}%, 0)`);

        } ).onStart(function() {

          nextPanelPosition = Math.max(0, Math.min(50, nextPanelPosition))
          tween.to( { x: nextPanelPosition } );
          panelIndex = nextPanelPosition / 25 >> 0;
          app.loader.reset();
          app.loader.stop();

          checkNavigation();

          panels[panelIndex].container.addClass('active');
          panels[panelIndex].container.removeClass('panel-prev panel-next');

        }).onComplete(function(){

          app.loader.start();

        });

class Panel{
  constructor($element, index){

    this.container = $element;
    this.index = index;
    this.canvas = $element.children('canvas')[0];
    this.ctx = this.canvas.getContext('2d');
    this.color = colors[index];

    this.canvas.width = 540;
    this.canvas.height = 210;

  }
}

$('.panel').forEach(function(item, index){

  panels[index] = new Panel($(item), index)

});

$(window).on('resize', function(){

  for (let i = 0; i < panels.length; i++) {
    panels[i].canvas.width = panels[i].container.width();
  };

});

function checkNavigation(){
  if(panelIndex == 0){
    $prev.addClass('hide');
  } else {
    $prev.removeClass('hide');
  }

  if(panelIndex == panels.length - 1){
    $next.addClass('hide');
  } else {
    $next.removeClass('hide');
  }
}


function next(){
  tween.stop();
  panels[panelIndex].container.removeClass('active');
  panels[panelIndex].container.addClass('panel-next');
  nextPanelPosition += 25;
  tween.start();
  state = 'forward';
}

function prev(){
  tween.stop();
  panels[panelIndex].container.removeClass('active');
  panels[panelIndex].container.addClass('panel-prev');
  nextPanelPosition -= 25;
  tween.start();
  state = 'back';
}

$next.on('click', next);
$prev.on('click', prev);

class Loader{

  constructor(){
    var self = this;
    /*
    * Percentage in float numbers
    */
    this.percentage = 0;

    this.radialPercentage = 0;

    this.pause = false;

    this.tween =  new TWEEN.Tween( {percentage: 0} )
        .to( { percentage: 1 }, 5000 )
        .easing( TWEEN.Easing.Circular.In )
        .onUpdate( function () {

          self.percentage = this.percentage;

        } ).onStart(function() {

          this.percentage = 0;

        }).onComplete(function(){

          if(panelIndex == 0) state = 'forward';
          if(panelIndex == panels.length - 1) state = 'back';

          if(state == 'forward') {
            next();
            return false;
          };

          prev();

        });

    this.tween.start();

  }

  setPercentage(percentage = 0){
    this.percentage = percentage;
  }

  reset(){

    this.percentage = 0;
    this.radialPercentage = 0;

  }

  start(){
    this.pause = false;
    this.tween.start();
  }

  stop(){
    this.pause = true;
    this.tween.stop();
  }

}

class APP{
  constructor(){

    this.loader = new Loader();

    //set the right size on start
    for (let i = 0; i < panels.length; i++) {
      panels[i].canvas.width = panels[i].container.width();
    };

    requestAnimationFrame(this.step.bind(this));

  }

  update(){

    start = (panels[panelIndex].canvas.width / 2) - 100;
    end = (panels[panelIndex].canvas.width / 2) + 100;
    barSize = (panels[panelIndex].canvas.width * this.loader.percentage) - start;
    per = ((barSize) / (end - start));

    this.loader.radialPercentage = (per);

  }

  draw(){


    panels[panelIndex].ctx.save();
    panels[panelIndex].ctx.strokeStyle = panels[panelIndex].color;
    panels[panelIndex].ctx.fillStyle = panels[panelIndex].color;
    panels[panelIndex].ctx.fillRect(0, (panels[panelIndex].canvas.height / 2) - 2, panels[panelIndex].canvas.width * this.loader.percentage, 4);

    panels[panelIndex].ctx.translate(panels[panelIndex].canvas.width / 2, panels[panelIndex].canvas.height / 2);
    panels[panelIndex].ctx.rotate(180 * TO_RAD);
    panels[panelIndex].ctx.translate(-(panels[panelIndex].canvas.width / 2), -(panels[panelIndex].canvas.height / 2));

    panels[panelIndex].ctx.lineWidth = 4;
    panels[panelIndex].ctx.beginPath();
    panels[panelIndex].ctx.arc(panels[panelIndex].canvas.width / 2, panels[panelIndex].canvas.height / 2, 102, 0, (Math.PI) * Math.max(0, Math.min(1, this.loader.radialPercentage)), false);
    panels[panelIndex].ctx.stroke();

    panels[panelIndex].ctx.beginPath();
    panels[panelIndex].ctx.globalCompositeOperation = 'destination-out';
    panels[panelIndex].ctx.arc(panels[panelIndex].canvas.width / 2, panels[panelIndex].canvas.height / 2, 100, 0, PI_TWO, false);
    panels[panelIndex].ctx.closePath();
    panels[panelIndex].ctx.fill();

    panels[panelIndex].ctx.restore();


  }

  step(){
    requestAnimationFrame(this.step.bind(this));

    var delta = Date.now() - this.lastTick;
    this.lastTick = Date.now();

    var dt = delta / 1000;

    this.elapsed = dt;

    TWEEN.update();

    panels[panelIndex].ctx.clearRect(0,0,panels[panelIndex].canvas.width, panels[panelIndex].canvas.height);

    this.update();

    this.draw();

  }

}

const app = new APP();
