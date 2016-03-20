using Toybox.Application as App;

class SlowWatchApp extends App.AppBase {

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new SlowWatchView() ];
    }

}
