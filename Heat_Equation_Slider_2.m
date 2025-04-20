clear;
clc;
close all;

interactive_heat_equation()

function interactive_heat_equation()
    % Grid size
    Nx = 100; Ny = 100; % Grid resolution
    dx = 1; dy = 1; % Space step
    dt = .2; % Time step
    alpha = 0.5; % Diffusion coefficient
    k = alpha * dt / (dx^2); % Stability condition (should be < 0.25 for explicit method)
    % Initialize temperature field
    T = 0.5+zeros(Nx, Ny); % Initial temperature (cold)

    % Set up the figure
    fig = figure;
    ax = axes(fig);
    xlim([0 100]);
    ylim([0,100]);
    sld = uicontrol(fig,"Style","slider");
    % sld.Limits = [0 1];
    
    h = imagesc(T, [0, 1]); % Heatmap visualization
    colormap hot; 
    colorbar;

    title('Click and Drag - 2D Heat Diffusion');
    axis equal;
    axis off;

    % Set up mouse click callback on the figure
    set(fig, 'WindowButtonMotionFcn', @mouseClick);

     % Keep running the heat equation in a loop
     while ishandle(h)
        % Apply the 2D heat equation (explicit method)
        T_new = T;
        for i = 2:Nx-1
            for j = 2:Ny-1
                T_new(i,j) = T(i,j) + k * (T(i+1,j) + T(i-1,j) + T(i,j+1) + T(i,j-1) - 4*T(i,j));
            end
        end


        T = T_new;
        
        % Update the visualization
        set(h, 'CData', T);
        drawnow;

     end

     function mouseClick(src, ~)
         seltype = sld.Value;
         src.WindowButtonUpFcn = @wbucb; % lets stop dragging

         % Get the mouse click position in axis coordinates
         coords = get(ax, 'CurrentPoint');        
         x = round(coords(1,1));
         y = round(coords(1,2));

         % Ensure valid indices (flip y-axis to match MATLAB image coordinates)
         if x >= 1 && x <= Nx-5 && y >= 1 && y <= Ny-5
            T(y:y+5, x:x+5) = seltype; % "Paint" heat on the grid (flip x-y for correct indexing)
         end
         

        % cp = src.CurrentPoint;
        % xinit = cp(1,1);
        % yinit = cp(1,2);
        
        
        
        % elseif y+5 >= Ny
        %     T(y,x:x+5) = 1;
        % elseif x+5 >= Nx
        %     T(y:y+5,x) = 1;
        % elseif y+5 >= Ny && x+5 >= Nx
        %     T(y,x) = 1;
        end
        % function wbmcb(src,~)
        %    cp = src.CurrentPoint;
        %    xdat = [xinit,cp(1,1)];
        %    ydat = [yinit,cp(1,2)];
        %    % % hl.XData = xdat;
        %    % % hl.YData = ydat;
        %    % drawnow
        % end
        % 
        function wbucb(src,~)
           last_seltype = src.SelectionType;
           % disp(last_seltype)
           
           if strcmp(last_seltype,'alt')
              % src.Pointer = 'arrow';
              % src.WindowButtonMotionFcn = '';
              src.WindowButtonMotionFcn = @restart;
              src.WindowButtonUpFcn = '';
           else
              return
           end
        end

        function restart(src,~)
            nextseltype = src.SelectionType;
            % disp(nextseltype)

            if strcmp(nextseltype,'normal')|strcmp(nextseltype,'open')
                src.WindowButtonMotionFcn = @mouseClick;
            end
        end
        
     end
