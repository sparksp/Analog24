using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class SlowWatchView extends Ui.WatchFace {

    hidden var radius, centerX, centerY;

    function onLayout(dc) {
        centerX = dc.getWidth() / 2;
        centerY = dc.getHeight() / 2;
        radius = centerX > centerY ? centerY : centerX;
    }

    //! Update the view
    function onUpdate(dc) {
        clear(dc);
        drawDial(dc);
        drawHand(dc);
    }

    //! Clear the screen
    hidden function clear(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
    }

    //! Draw the watch dial
    hidden function drawDial(dc) {
        var oedge = radius + 1;
        var radians = Math.PI / 48.0; // * 2.0 / 96.0

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        for (var i = 0, angle = 0; i < 13; i += 1) {
            var iedge, cos, sin, x1, y1, x2, y2;

            if (i % 4 == 0) { // Hours
                dc.setPenWidth(3);
                // Longer dashes every 3 hours
                iedge = oedge - ((i % 12 == 0) ? 10 : 5);
            }
            else { // Minutes
                dc.setPenWidth(1);
                iedge = oedge - 5;
            }

            cos = Math.cos(angle);
            sin = Math.sin(angle);

            x1 = cos * iedge;
            y1 = sin * iedge;
            x2 = cos * oedge;
            y2 = sin * oedge;

            dc.drawLine(centerX + x1, centerY + y1, centerX + x2, centerY + y2);
            dc.drawLine(centerX - x1, centerY - y1, centerX - x2, centerY - y2);
            dc.drawLine(centerX - x1, centerY + y1, centerX - x2, centerY + y2);
            dc.drawLine(centerX + x1, centerY - y1, centerX + x2, centerY - y2);
            dc.drawLine(centerX + y1, centerY + x1, centerX + y2, centerY + x2);
            dc.drawLine(centerX - y1, centerY - x1, centerX - y2, centerY - x2);
            dc.drawLine(centerX - y1, centerY + x1, centerX - y2, centerY + x2);
            dc.drawLine(centerX + y1, centerY - x1, centerX + y2, centerY - x2);

            angle += radians;
        }
    }


    //! Draw the hand
    hidden function drawHand(dc) {
        var angle = timeAngle();
        var cos = Math.cos(angle) * radius;
        var sin = Math.sin(angle) * radius;

        var rangle = angle + (Math.PI / 2);
        var rcos = Math.cos(rangle) * 3;
        var rsin = Math.sin(rangle) * 3;

        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_ORANGE);
        dc.setPenWidth(1);
        dc.fillPolygon([
            [centerX + cos, centerY + sin],
            [centerX + rcos, centerY + rsin],
            [centerX - (cos / radius * 6), centerY - (sin / radius * 6)],
            [centerX - rcos, centerY - rsin]
        ]);
    }

    hidden const MINUTES_PER_HOUR = 60.0;
    hidden const MINUTES_PER_DAY = 1440.0;
    //! Shift time by 6 hours so that midnight is at the bottom
    hidden const CLOCK_OFFSET = 360.0;

    //! Angle for the current time.
    //! @returns time as an angle
    hidden function timeAngle() {
        var time = Sys.getClockTime();
        var minutes = time.min + (time.hour * MINUTES_PER_HOUR);

        // Convert to radians
        return ((minutes + CLOCK_OFFSET) / MINUTES_PER_DAY) * Math.PI * 2.0;
    }
}
