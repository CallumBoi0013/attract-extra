//Thanks Oomek!
class SmoothInterpolator extends Interpolator {
    overshoot = 0.01;
    smoothing = 0.9;

    constructor( overshoot = 0.01, smoothing = 0.9 ) {
        this.overshoot = overshoot;
        this.smoothing = smoothing;
    }
    
    function interpolate( from, to, progress ) {
        if ( from != to )
            if ( from > to ) {
                from = from * smoothing + ( to - overshoot ) * ( 1 - smoothing );
                if ( from < to ) from = to;
            } else if ( from < to ) {
                from = from * smoothing + ( to + overshoot ) * ( 1 - smoothing );
                if ( from > to ) from = to;
            }
        print( "from: " + from + " to: " + to);
        return from;
    }
}