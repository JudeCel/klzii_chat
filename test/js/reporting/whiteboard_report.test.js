import {assert} from 'chai';
import 'jsdom-global/register'
var jsdom = require('jsdom')
import whiteboardReport  from '../../../web/static/js/reporting/whiteboard_report';

var defaultHtml = '<!doctype html><html><head><meta charset="utf-8">' +
  `</head><body>
    <div class="whiteboard-frame">
      <svg class="whiteboard">
        <g id="whiteboard_1"></g>
      </svg>
    </div>
  </body></html>`

describe("test Whiteboard report", () => {
  var json = "[{"uid":"SvgjsSvg1026polyline1485768009860","time":"2017-01-30T09:20:10.166852","sessionTopicId":1,"id":1,"event":{"id":"SvgjsSvg1026polyline1485768009860","element":"<polyline id=\"SvgjsSvg1026polyline1485768009860\" points=\"228.44139099121094,227.28179931640625 228.44139099121094,227.28179931640625 229.60099750623442,227.28179551122196 231.92019950124688,227.28179551122196 234.23940149625938,227.28179551122196 240.03740648379053,229.60099750623442 246.99501246882795,233.07980049875312 258.59102244389027,237.71820448877807 272.5062344139651,244.67581047381546 289.90024937655863,252.7930174563591 307.2942643391521,260.91022443890273 324.68827930174564,269.0274314214464 342.08229426433917,277.14463840399003 360.63591022443893,285.26184538653365 379.1895261845387,288.7406483790524 395.42394014962593,291.05985037406487 411.65835411471323,294.53865336658356 425.57356608478807,296.857855361596 439.48877805486285,296.857855361596 447.6059850374065,296.857855361596 455.72319201995015,296.857855361596 462.68079800498754,296.857855361596 467.31920199501246,295.6982543640898 468.47880299251875,294.53865336658356 467.31920199501246,294.53865336658356 466.15960099750623,294.53865336658356 463.84039900249377,294.53865336658356 461.5211970074813,294.53865336658356 460.3615960099751,294.53865336658356 459.20199501246884,294.53865336658356\" fill=\"none\" stroke=\"#e51e39\" stroke-width=\"2\" pointer-events=\"all\"></polyline>"}},{"uid":"SvgjsSvg1030polyline1485768010491","time":"2017-01-30T09:20:10.804525","sessionTopicId":1,"id":2,"event":{"id":"SvgjsSvg1030polyline1485768010491","element":"<polyline id=\"SvgjsSvg1030polyline1485768010491\" points=\"498.62841796875,206.4089813232422 498.62841796875,206.4089813232422 497.4688279301746,205.2493765586035 493.9900249376559,205.2493765586035 488.1920199501247,206.40897755610973 477.7556109725686,213.36658354114715 461.5211970074813,220.32418952618454 440.6483790523691,231.92019950124688 420.9351620947631,243.51620947630923 404.70074812967584,251.63341645885288 384.98753117206985,264.3890274314215 364.1147132169576,275.9850374064838 344.40149625935163,288.7406483790524 323.5286783042394,298.01745635910225 302.6558603491272,307.2942643391521 282.9426433915212,317.73067331670825 262.06982543640896,332.8054862842893 240.03740648379053,345.56109725685786 218.00498753117208,359.4763092269327 194.8129675810474,372.23192019950125 178.57855361596012,386.1471321695761 162.34413965087282,393.1047381546135 146.10972568578555,403.5411471321696 133.35411471321697,407.0199501246883 124.07730673316709,410.498753117207\" fill=\"none\" stroke=\"#e51e39\" stroke-width=\"2\" pointer-events=\"all\"></polyline>"}}]"

  describe("element adding.", () => {
    before(() => {
      var document = jsdom.jsdom(defaultHtml)
      window = document.defaultView
      window.Snap = require('snapsvg');
      window.$ = require('jquery')
    })

    it("Add elements to svg class", () => {
      whiteboardReport.drawElements("#whiteboard_1", JSON.parse(json));
      assert.equal(window.$("svg g#whiteboard_1").children().length, 11);
    });
  });
});
