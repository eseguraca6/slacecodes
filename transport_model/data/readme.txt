So, here's the thing: 

You have to address how the beam is magnified as it goes through the beam expander (telescope?), and through the relay lens
(relay image) 

the data is for:

1. a drift halfway L_2-L_3. 
2. a drift halfway M_5-M_6
3. a drift for L4 (right after)
4. a drift for halfway between L4 and the compressor. 

Next, you need to address collimation issues (whethere the beam is indeed collimated, and if not by how much
it is not collimated?)

So: 

1. You need to make drifts up to a raleigh range (that's our "guarantee" for the beam to stay collimated) 
2. Quantify the changes (whatever are those dunno).

Settings for ZEMAX:

Waist: 5x5mm (remember the adjustment by 2 to configure for our physics for ZEMAX differs from our form; 
for us waist is the beam waist at z=0; for ZEMAX, it's at full width...)

Sampling:2048x2048 mm 

Window: 80x80 mm (overshooting the size of the minimal component)

Ta-da!