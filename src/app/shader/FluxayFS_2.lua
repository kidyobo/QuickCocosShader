return [[
    #define TAU 6.120470874064187
    #define MAX_ITER 5
    uniform float time; 
    varying vec2 v_texCoord;
    varying vec4 v_fragmentColor;
    void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
    {
        float time = time * .5+5.;
        // uv should be the 0-1 uv of texture...
        vec2 uv = v_texCoord.xy;//fragCoord.xy / iResolution.xy;
        

        vec2 p = mod(uv*TAU, TAU)-250.0;

        vec2 i = vec2(p);
        float c = 1.0;
        float inten = .0045;

        for (int n = 0; n < MAX_ITER; n++) 
        {
            float t =  time * (1.0 - (3.5 / float(n+1)));
            i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(1.5*t + i.x));
            c += 1.0/length(vec2(p.x / (cos(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
        }
        c /= float(MAX_ITER);
        c = 1.17-pow(c, 1.4);
        vec4 tex = texture2D(CC_Texture0,uv);
        vec3 colour = vec3(pow(abs(c), 20.0));
        colour = clamp(colour + vec3(0.0, 0.0, .0), 0.0, tex.a);

        // 混合波光
        float alpha = c*tex[3];  
        tex[0] = tex[0] + colour[0]*alpha; 
        tex[1] = tex[1] + colour[1]*alpha; 
        tex[2] = tex[2] + colour[2]*alpha; 
        fragColor = v_fragmentColor * tex;
    }
    void main()
    {
        mainImage(gl_FragColor, gl_FragCoord.xy);
    }
]]
