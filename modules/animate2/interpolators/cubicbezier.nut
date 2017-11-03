//This is not working!
class CubicBezierInterpolator extends Interpolator {
    bezier = [0.25, 0.1, 0.25, 1.0];

    constructor() {

    }
    
    function interpolate( from, to, progress ) {
        return from + ( to - from ) * cubicBezier( progress, bezier[0], bezier[1], bezier[2], bezier[3] );
    }

    function cubicBezier (x, a, b, c, d)
    {
        local y0a = 0.00; // initial y
        local x0a = 0.00; // initial x 
        local y1a = b;    // 1st influence y   
        local x1a = a;    // 1st influence x 
        local y2a = d;    // 2nd influence y
        local x2a = c;    // 2nd influence x
        local y3a = 1.00; // final y 
        local x3a = 1.00; // final x 

        local A = x3a - 3*x2a + 3*x1a - x0a;
        local B = 3*x2a - 6*x1a + 3*x0a;
        local C = 3*x1a - 3*x0a;
        local D = x0a;

        local E =   y3a - 3*y2a + 3*y1a - y0a;    
        local F = 3*y2a - 6*y1a + 3*y0a;
        local G = 3*y1a - 3*y0a;
        local H =   y0a;
        
        // Solve for t given x (using Newton-Raphelson), then solve for y given t.
        // Assume for the first guess that t = x.
        local currentt = x.tofloat();
        local nRefinementIterations = 5;
        for (local i = 0; i < nRefinementIterations; i++)
        {
            local currentx = xFromT (currentt, A,B,C,D); 
            local currentslope = slopeFromT (currentt, A,B,C);
            currentt -= (currentx - x)*(currentslope);
            currentt = clamp(currentt, 0,1);
        } 
        local y = yFromT (currentt,  E,F,G,H);
        return y;
    }

    // Helper functions:
    function slopeFromT (t, A, B, C)
    {
        local dtdx = 1.0/(3.0*A*t*t + 2.0*B*t + C); 
        return dtdx;
    }

    function xFromT (t, A, B, C, D)
    {
        local x = A*(t*t*t) + B*(t*t) + C*t + D;
        return x * 1.0;
    }

    function yFromT (t, E, F, G, H)
    {
        local y = E*(t*t*t) + F*(t*t) + G*t + H;
        return y;
    }

    function clamp(value, min, max) {
        if (value < min) value = min; if (value > max) value = max; return value
    }

}