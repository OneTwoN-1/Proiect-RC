function Gui()
%GUI -
    antennaType = 'Izotropică';
    sc_handle   = [];

    % Stare fereastra de comparatie (suprapunere rulari)
    compFig      = [];
    axCompare    = [];
    axCompareVis = [];
    runIdx       = 0;

    % ---- Figura principala ----
    hFig = figure( ...
        'Name',        'Satellite Communications for ADS-B Out', ...
        'NumberTitle', 'off', ...
        'Position',    [40, 40, 1280, 760], ...
        'Color',       [0.13 0.13 0.13], ...
        'Resize',      'on');
    hFig.CloseRequestFcn = @(~,~) delete(hFig);


    % PANEL STANG

    pL = uipanel(hFig, ...
        'Title',           'Parametri de Intrare', ...
        'Units',           'normalized', ...
        'Position',        [0.005 0.01 0.275 0.98], ...
        'BackgroundColor', [0.18 0.18 0.18], ...
        'ForegroundColor', [0.90 0.90 0.90], ...
        'FontSize',        10, ...
        'FontWeight',      'bold');

    % Frecventa ADS-B (informativ, linie unica)
    uicontrol(pL,'Style','text','String','Frecvență ADS-B', ...
        'Units','normalized','Position',[0.05 0.924 0.56 0.038], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.58 0.58 0.58], ...
        'HorizontalAlignment','left','FontSize',9);
    uicontrol(pL,'Style','text','String','1090 MHz', ...
        'Units','normalized','Position',[0.61 0.924 0.34 0.038], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.20 0.85 0.20], ...
        'HorizontalAlignment','right','FontSize',9,'FontWeight','bold');

    % Separator 
    uicontrol(pL,'Style','text','String','', ...
        'Units','normalized','Position',[0.05 0.916 0.90 0.004], ...
        'BackgroundColor',[0.35 0.35 0.35]);

    % Tip antena - eticheta
    uicontrol(pL,'Style','text','String','Tip Antenă pe Satelit:', ...
        'Units','normalized','Position',[0.05 0.876 0.90 0.036], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.90 0.90 0.90], ...
        'HorizontalAlignment','left','FontSize',9,'FontWeight','bold');

    % Dropdown tip antena
    ddAntenna = uicontrol(pL, ...
        'Style',           'popupmenu', ...
        'String',          {'Izotropică','48 Fascicule Personalizate (Phased Array)'}, ...
        'Units',           'normalized', ...
        'Position',        [0.05 0.815 0.90 0.055], ...
        'BackgroundColor', [0.28 0.28 0.28], ...
        'ForegroundColor', [0.95 0.95 0.95], ...
        'FontSize',        9, ...
        'Callback',        @cbAntennaChange);

    % Caracteristici antena - eticheta
    uicontrol(pL,'Style','text','String','Caracteristici Antenă:', ...
        'Units','normalized','Position',[0.05 0.778 0.90 0.030], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.55 0.55 0.55], ...
        'HorizontalAlignment','left','FontSize',8);

    % Listbox readonly
    lstCaract = uicontrol(pL, ...
        'Style',           'listbox', ...
        'String',          getAntennaCharacteristics('Izotropică'), ...
        'Units',           'normalized', ...
        'Position',        [0.05 0.660 0.90 0.114], ...
        'BackgroundColor', [0.22 0.22 0.22], ...
        'ForegroundColor', [0.72 0.94 0.72], ...
        'FontSize',        8, ...
        'Enable',          'inactive');

    % Separator
    uicontrol(pL,'Style','text','String','', ...
        'Units','normalized','Position',[0.05 0.652 0.90 0.004], ...
        'BackgroundColor',[0.35 0.35 0.35]);

    % Unghiuri de montaj antena satelit (editabile)
    uicontrol(pL,'Style','text','String','Unghiuri Montaj Satelit (grade):', ...
        'Units','normalized','Position',[0.05 0.616 0.90 0.030], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.90 0.90 0.90], ...
        'HorizontalAlignment','left','FontSize',9,'FontWeight','bold');

    % Sub-etichete Yaw / Pitch / Roll
    uicontrol(pL,'Style','text','String','Yaw', ...
        'Units','normalized','Position',[0.05 0.586 0.28 0.026], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.60 0.60 0.60], ...
        'HorizontalAlignment','center','FontSize',8);
    uicontrol(pL,'Style','text','String','Pitch', ...
        'Units','normalized','Position',[0.36 0.586 0.28 0.026], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.60 0.60 0.60], ...
        'HorizontalAlignment','center','FontSize',8);
    uicontrol(pL,'Style','text','String','Roll', ...
        'Units','normalized','Position',[0.67 0.586 0.28 0.026], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.60 0.60 0.60], ...
        'HorizontalAlignment','center','FontSize',8);

    % Casute editabile Yaw / Pitch / Roll (implicit pentru Izotropică)
    hYaw = uicontrol(pL,'Style','edit','String','0', ...
        'Units','normalized','Position',[0.05 0.536 0.28 0.046], ...
        'BackgroundColor',[0.28 0.28 0.28],'ForegroundColor',[0.95 0.95 0.95], ...
        'FontSize',9,'HorizontalAlignment','center');
    hPitch = uicontrol(pL,'Style','edit','String','0', ...
        'Units','normalized','Position',[0.36 0.536 0.28 0.046], ...
        'BackgroundColor',[0.28 0.28 0.28],'ForegroundColor',[0.95 0.95 0.95], ...
        'FontSize',9,'HorizontalAlignment','center');
    hRoll = uicontrol(pL,'Style','edit','String','0', ...
        'Units','normalized','Position',[0.67 0.536 0.28 0.046], ...
        'BackgroundColor',[0.28 0.28 0.28],'ForegroundColor',[0.95 0.95 0.95], ...
        'FontSize',9,'HorizontalAlignment','center');

    % Separator
    uicontrol(pL,'Style','text','String','', ...
        'Units','normalized','Position',[0.05 0.524 0.90 0.004], ...
        'BackgroundColor',[0.35 0.35 0.35]);

    % Stare - eticheta + casuta separata
    uicontrol(pL,'Style','text','String','Stare:', ...
        'Units','normalized','Position',[0.05 0.494 0.90 0.026], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.52 0.52 0.52], ...
        'HorizontalAlignment','left','FontSize',8,'FontWeight','bold');
    hStatus = uicontrol(pL,'Style','text','String','Gata!', ...
        'Units','normalized','Position',[0.05 0.436 0.90 0.054], ...
        'BackgroundColor',[0.21 0.21 0.21],'ForegroundColor',[0.20 0.85 0.20], ...
        'HorizontalAlignment','center','FontSize',9,'FontWeight','bold');

    % Separator
    uicontrol(pL,'Style','text','String','', ...
        'Units','normalized','Position',[0.05 0.428 0.90 0.004], ...
        'BackgroundColor',[0.35 0.35 0.35]);

    % Sectiune Actiuni
    uicontrol(pL,'Style','text','String','ACȚIUNI', ...
        'Units','normalized','Position',[0.05 0.396 0.90 0.028], ...
        'BackgroundColor',[0.18 0.18 0.18],'ForegroundColor',[0.65 0.65 0.65], ...
        'HorizontalAlignment','left','FontSize',9,'FontWeight','bold');
    uicontrol(pL,'Style','text','String','', ...
        'Units','normalized','Position',[0.05 0.389 0.90 0.004], ...
        'BackgroundColor',[0.35 0.35 0.35]);

    % Buton Ruleaza Simularea
    btnRun = uicontrol(pL, ...
        'Style','pushbutton','String','RULEAZĂ SIMULAREA', ...
        'Units','normalized','Position',[0.05 0.300 0.90 0.084], ...
        'BackgroundColor',[0.16 0.46 0.80],'ForegroundColor','white', ...
        'FontSize',10,'FontWeight','bold','Callback',@(~,~) cbRunSim());

    % Buton Deschide Documentatie
    uicontrol(pL, ...
        'Style','pushbutton','String','Deschide Documentația', ...
        'Units','normalized','Position',[0.05 0.200 0.90 0.084], ...
        'BackgroundColor',[0.42 0.22 0.60],'ForegroundColor','white', ...
        'FontSize',10,'FontWeight','bold','Callback',@(~,~) cbOpenDoc());

    % Buton Reset
    uicontrol(pL, ...
        'Style','pushbutton','String','Resetează', ...
        'Units','normalized','Position',[0.05 0.100 0.90 0.084], ...
        'BackgroundColor',[0.58 0.20 0.16],'ForegroundColor','white', ...
        'FontSize',10,'FontWeight','bold','Callback',@(~,~) cbReset());


    % PANEL DREAPTA

    pR = uipanel(hFig, ...
        'Title',           'Rezultate', ...
        'Units',           'normalized', ...
        'Position',        [0.285 0.01 0.710 0.98], ...
        'BackgroundColor', [0.13 0.13 0.13], ...
        'ForegroundColor', [0.90 0.90 0.90], ...
        'FontSize',        10, ...
        'FontWeight',      'bold');

    % Titlu sectiune antena (cu tipul curent)
    hLblAntenna = uicontrol(pR,'Style','text', ...
        'String','Model Radiație Antenă  |  Izotropică', ...
        'Units','normalized','Position',[0.02 0.955 0.96 0.034], ...
        'BackgroundColor',[0.13 0.13 0.13],'ForegroundColor',[0.95 0.95 0.95], ...
        'HorizontalAlignment','center','FontSize',11,'FontWeight','bold');

    % Axe diagrama antena (3D) - ocupa tot panoul din dreapta
    axAntenna = axes('Parent',pR, ...
        'Units','normalized','Position',[0.08 0.07 0.86 0.86], ...
        'Color',[0.09 0.09 0.09], ...
        'XColor',[0.60 0.60 0.60],'YColor',[0.60 0.60 0.60],'ZColor',[0.60 0.60 0.60], ...
        'GridColor',[0.32 0.32 0.32],'GridAlpha',0.5);

    % Afisam diagrama antena initiala
    plotAntennaPattern(axAntenna, 'Izotropică');


    % FUNCTII 
    function cbAntennaChange(src, ~)
        types = {'Izotropică','48 Fascicule Personalizate (Phased Array)'};
        antennaType = types{src.Value};
        hLblAntenna.String = ['Model Radiație Antenă  |  ' antennaType];
        plotAntennaPattern(axAntenna, antennaType);
        lstCaract.String = getAntennaCharacteristics(antennaType);
        % Actualizam unghiurile implicite de montaj in functie de tip
        if strcmp(antennaType, 'Izotropică')
            hYaw.String = '0';  hPitch.String = '0';   hRoll.String = '0';
        else
            hYaw.String = '0';  hPitch.String = '-90';  hRoll.String = '0';
        end
        setStatus('Antenă schimbată. Rulați simularea.', [0.92 0.70 0.10]);
    end

    function cbRunSim()
        btnRun.Enable = 'off';
        setStatus('Se construiește scenariul ...', [0.92 0.70 0.10]);
        drawnow;
        try
            [sc, aircraft, iridiumSats, iridiumConicalSensors, txADSB, rxAirport] = buildScenario();
            sc_handle = sc;

            % Cream viewer-ul explicit si centram camera pe avion de la
            % inceput
            viewer = satelliteScenarioViewer(sc);
            camtarget(viewer, aircraft);

            fADSB = 1090e6;
            setStatus('Se configurează antena satelit ...', [0.92 0.70 0.10]);
            drawnow;

            mAng = getMountingAngles();   % [Yaw, Pitch, Roll] din casute

            if strcmp(antennaType, 'Izotropică')
                satAnt = arrayConfig("Size",[1 1]);
                rxSat  = receiver(iridiumSats, ...
                    Antenna=satAnt, MountingAngles=mAng, ...
                    Name=iridiumSats.Name + " Receptor");
                pattern(rxSat, fADSB, Size=50000);
            else
                satAnt = HelperCustom48BeamAntenna(fADSB);
                rxSat  = receiver(iridiumSats, ...
                    Antenna=satAnt, MountingAngles=mAng, ...
                    Name=iridiumSats.Name + " Receptor");
                pattern(rxSat, fADSB, Size=200000);
            end

            % Bilant Legatura - o singura calculare
            setStatus('Se calculează Bilanțul de Legătură ...', [0.92 0.70 0.10]);
            drawnow;
            lnk      = link(txADSB, [rxAirport, rxSat]);
            [eL, t]  = ebno(lnk);
            marg     = eL - repmat([rxAirport.RequiredEbNo, rxSat.RequiredEbNo]', ...
                           [1, size(eL,2)]);

            % Pregatim fereastra de comparatie si o noua culoare/eticheta
            % pentru aceasta rulare
            runIdx = runIdx + 1;
            ensureCompareWindow();
            cOrd   = lines(7);
            runCol = cOrd(mod(runIdx-1,7)+1, :);
            lblRun = sprintf('Rul %d: %s  [Y%g P%g R%g]', ...
                runIdx, antennaType, mAng(1), mAng(2), mAng(3));

            % Bilant Legatura - suprapus peste rularile anterioare
            plot(axCompare, t, max(marg), 'Color', runCol, ...
                'LineWidth', 1.6, 'DisplayName', lblRun);
            axis(axCompare, 'tight');
            legend(axCompare, 'show', 'TextColor', [0.85 0.85 0.85], ...
                'Color', [0.16 0.16 0.16], 'EdgeColor', [0.35 0.35 0.35], ...
                'Location', 'best');

            % Vizibilitate sateliti - suprapusa peste rularile anterioare
            setStatus('Se calculează vizibilitatea sateliților ...', [0.92 0.70 0.10]);
            drawnow;
            acSatellite = access(aircraft, iridiumConicalSensors);
            [sSatellite, timeVis] = accessStatus(acSatellite);
            satVisData = double(sSatellite);
            satVisData(satVisData == 0) = NaN;
            satVisData = satVisData + (0:numel(iridiumSats)-1)';
            % Prima linie poarta eticheta de legenda; restul sunt ascunse
            hV = plot(axCompareVis, timeVis, satVisData, '.', ...
                'Color', runCol, 'MarkerSize', 4);
            if ~isempty(hV)
                set(hV, 'HandleVisibility', 'off');
                set(hV(1), 'HandleVisibility', 'on', 'DisplayName', lblRun);
            end
            yticks(axCompareVis, 1:5:66);
            yticklabels(axCompareVis, iridiumSats.Name(1:5:66));
            axis(axCompareVis, 'tight');
            legend(axCompareVis, 'show', 'TextColor', [0.85 0.85 0.85], ...
                'Color', [0.16 0.16 0.16], 'EdgeColor', [0.35 0.35 0.35], ...
                'Location', 'best');

            setStatus('Gata! Se lansează vizualizatorul ...', [0.18 0.85 0.18]);
            drawnow;

            % O singura lansare a scenariului principal
            play(sc);

        catch ME
            setStatus(['Eroare: ' ME.message], [0.90 0.18 0.18]);
            warning(ME.identifier, '%s', ME.message);
        end
        btnRun.Enable = 'on';
    end

    function cbOpenDoc()
        docPath = fullfile(fileparts(mfilename('fullpath')), 'Proiect_RC.docx');
        if ~isfile(docPath)
            errordlg(['Fișierul nu a fost găsit:' newline docPath], ...
                'Eroare documentație');
            return;
        end
        try
            if ispc
                winopen(docPath);
            elseif ismac
                system(['open "' docPath '" &']);
            else
                system(['xdg-open "' docPath '" &']);
            end
        catch
            errordlg('Nu s-a putut deschide documentul Word.', 'Eroare');
        end
    end

    function cbReset()
        antennaType        = 'Izotropică';
        sc_handle          = [];
        ddAntenna.Value    = 1;
        lstCaract.String   = getAntennaCharacteristics('Izotropică');
        hLblAntenna.String = 'Model Radiație Antenă  |  Izotropică';
        plotAntennaPattern(axAntenna, 'Izotropică');

        % Readucem unghiurile de montaj la implicit (Izotropică)
        hYaw.String = '0';  hPitch.String = '0';  hRoll.String = '0';

        % Golim fereastra de comparatie (ambele grafice) si contorul
        runIdx = 0;
        if ~isempty(axCompare) && isgraphics(axCompare)
            cla(axCompare);
            legend(axCompare, 'off');
            title(axCompare, 'Comparație Bilanț de Legătură (Marjă vs. Timp)', ...
                'Color', [0.92 0.92 0.92]);
            xlabel(axCompare, 'Timp', 'Color', [0.60 0.60 0.60]);
            ylabel(axCompare, 'Marjă (dB)', 'Color', [0.60 0.60 0.60]);
            grid(axCompare, 'on');
        end
        if ~isempty(axCompareVis) && isgraphics(axCompareVis)
            cla(axCompareVis);
            legend(axCompareVis, 'off');
            title(axCompareVis, 'Comparație Vizibilitate Sateliți', ...
                'Color', [0.92 0.92 0.92]);
            xlabel(axCompareVis, 'Timp', 'Color', [0.60 0.60 0.60]);
            ylabel(axCompareVis, 'Satelit Iridium', 'Color', [0.60 0.60 0.60]);
            grid(axCompareVis, 'on');
        end

        setStatus('Resetat.', [0.18 0.85 0.18]);
    end

    function setStatus(msg, col)
        hStatus.String          = msg;
        hStatus.ForegroundColor = col;
        drawnow;
    end

    % Citeste si valideaza unghiurile de montaj din casute.
    % Valoarea nevalida este tratata ca 0 si reflectata in casuta.
    function ang = getMountingAngles()
        hBoxes = [hYaw, hPitch, hRoll];
        ang    = zeros(1,3);
        for kk = 1:3
            v = str2double(hBoxes(kk).String);
            if isnan(v) || ~isfinite(v)
                v = 0;
                hBoxes(kk).String = '0';
            end
            ang(kk) = v;
        end
    end

    % Creeaza (sau reutilizeaza) fereastra separata de comparatie
    % in care rularile se suprapun pe acelasi grafic.
    function ensureCompareWindow()
        if ~isempty(compFig) && isgraphics(compFig) && ...
           ~isempty(axCompare) && isgraphics(axCompare) && ...
           ~isempty(axCompareVis) && isgraphics(axCompareVis)
            return;
        end
        compFig = figure( ...
            'Name',        'Comparație Rulări - Bilanț de Legătură & Vizibilitate', ...
            'NumberTitle', 'off', ...
            'Position',    [100, 140, 1320, 540], ...
            'Color',       [0.13 0.13 0.13]);

        % Bilant de legatura (stanga)
        axCompare = subplot(1,2,1,'Parent',compFig);
        set(axCompare, 'Color',[0.09 0.09 0.09], ...
            'XColor',[0.60 0.60 0.60],'YColor',[0.60 0.60 0.60], ...
            'GridColor',[0.32 0.32 0.32],'GridAlpha',0.5);
        hold(axCompare, 'on');
        grid(axCompare, 'on');
        title(axCompare, 'Comparație Bilanț de Legătură (Marjă vs. Timp)', ...
            'Color', [0.92 0.92 0.92]);
        xlabel(axCompare, 'Timp', 'Color', [0.60 0.60 0.60]);
        ylabel(axCompare, 'Marjă (dB)', 'Color', [0.60 0.60 0.60]);

        % Vizibilitate sateliti (dreapta)
        axCompareVis = subplot(1,2,2,'Parent',compFig);
        set(axCompareVis, 'Color',[0.09 0.09 0.09], ...
            'XColor',[0.60 0.60 0.60],'YColor',[0.60 0.60 0.60], ...
            'GridColor',[0.32 0.32 0.32],'GridAlpha',0.5, 'FontSize',7);
        hold(axCompareVis, 'on');
        grid(axCompareVis, 'on');
        title(axCompareVis, 'Comparație Vizibilitate Sateliți', ...
            'Color', [0.92 0.92 0.92]);
        xlabel(axCompareVis, 'Timp', 'Color', [0.60 0.60 0.60]);
        ylabel(axCompareVis, 'Satelit Iridium', 'Color', [0.60 0.60 0.60]);
    end

end  % end Gui()

%  buildScenario  -  Construieste scenariul satelit fara play()
function [sc, aircraft, iridiumSatellites, iridiumConicalSensors, txADSB, rxAirport] = buildScenario()
    startTime  = datetime(2026,4,9,15,55,0, TimeZone="Pacific/Auckland");
    stopTime   = startTime + hours(3) + minutes(50);
    sampleTime = 10;
    sc = satelliteScenario(startTime, stopTime, sampleTime);

    airportName = ["Aeroportul Internațional Wellington (Wellington)"; ...
                   "Aeroportul Kingsford Smith Sydney (Sydney)"];
    airportLat  = [-41.3272; -33.9548];
    airportLon  = [174.8052; 151.1897];
    airports    = groundStation(sc, airportLat, airportLon, Name=airportName);

    waypoints = [ ...
        -41.3272, 174.8052,    4; -41.4088, 174.7811,  609; ...
        -41.4424, 174.7494, 1219; -41.4298, 174.6538, 1828; ...
        -41.0500, 173.1000, 5500; -40.5500, 171.5000, 9000; ...
        -40.0000, 170.0000,11582; -39.2000, 167.0000,11582; ...
        -38.4000, 164.1000,11582; -37.5000, 161.1000,11582; ...
        -36.7000, 158.2000,11582; -35.9324, 155.2361,11582; ...
        -35.3403, 154.2447,11582; -35.1915, 153.9896,11277; ...
        -35.0398, 153.7313,11277; -34.8009, 153.3287,10500; ...
        -34.3358, 152.5571, 8229; -34.0329, 152.0384, 5181; ...
        -34.0017, 151.8044, 3657; -33.7669, 151.4050, 1524; ...
        -33.7430, 151.1863,  914; -33.7626, 151.1639,  914; ...
        -33.9548, 151.1897,    6];

    % Timpii scalati proportional astfel incat
    % avionul sa ajunga la Sydney exact la sfarsitul simularii (03:50:00).
    timeOfArrival = duration([ ...
        "00:00:00";"00:00:33";"00:01:25";"00:02:38";"00:07:14";"00:15:46"; ...
        "00:27:36";"00:53:53";"01:20:10";"01:46:27";"02:12:45";"02:39:02"; ...
        "02:50:51";"02:56:07";"03:01:22";"03:06:38";"03:15:50";"03:23:43"; ...
        "03:28:58";"03:34:14";"03:39:29";"03:43:26";"03:50:00"]);

    trajectory = geoTrajectory(waypoints, seconds(timeOfArrival), ...
        AutoPitch=true, AutoBank=true);
    aircraft = platform(sc, trajectory, Name="Avion", ...
        Visual3DModel="NarrowBodyAirliner.glb");

    % Constelatie Iridium NEXT - 66 sateliti, 6 plane orbitale
    numSatsPerPlane = 11;
    numOrbits       = 6;
    orbitIdx  = repelem(1:numOrbits, 1, numSatsPerPlane);
    planeIdx  = repmat(1:numSatsPerPlane, 1, numOrbits);
    RAAN      = 180*(orbitIdx-1)/numOrbits;
    trueanom  = 360*(planeIdx-1 + 0.5*(mod(orbitIdx,2)-1))/numSatsPerPlane;
    sma       = repmat((6371+780)*1e3, size(RAAN));

    iridiumSatellites = satellite(sc, sma, zeros(size(RAAN)), ...
        repmat(86.4,size(RAAN)), RAAN, zeros(size(RAAN)), trueanom, ...
        Name="Iridium " + string(1:66)');

    iridiumConicalSensors = conicalSensor(iridiumSatellites, "MaxViewAngle", 125);

    fADSB  = 1090e6;
    txAnt  = arrayConfig("Size",[1 1]);
    txADSB = transmitter(aircraft, ...
        Antenna=txAnt, Frequency=fADSB, Power=10*log10(125), ...
        MountingLocation=[8,0,-2.7], Name="Emițător ADS-B Avion");

    rxAnt     = arrayConfig("Size",[1 1]);
    rxAirport = receiver(airports, Antenna=rxAnt, Name=airports.Name + " Receptor");
    pattern(rxAirport, fADSB, Size=1000);
end



%  plotAntennaPattern  -  Deseneaza diagrama de radiatie 3D
function plotAntennaPattern(ax, antennaType)
    cla(ax);
    if strcmp(antennaType, 'Izotropică')
        [X,Y,Z] = sphere(80);
        G = zeros(size(X));
        surf(ax, X, Y, Z, G, 'EdgeColor','none', 'FaceAlpha',0.80);
        colormap(ax, parula);
        cb = colorbar(ax);
        ylabel(cb,'Câștig (dBi)');
        cb.Color = [0.62 0.62 0.62];
        axis(ax,'equal');
        view(ax, 3);
    else
        az = linspace(-pi, pi, 361);
        el = linspace(-pi/2, pi/2, 181);
        [AZ,EL] = meshgrid(az, el);
        Gpeak  = 24;
        bwHalf = 4*pi/180;
        bDirs  = generateBeamDirections(48);
        G      = -35*ones(size(AZ));
        for k = 1:size(bDirs,1)
            az0 = bDirs(k,1);
            el0 = bDirs(k,2);
            ang = acos(max(-1, min(1, ...
                cos(EL).*cos(AZ-az0).*cos(el0) + sin(EL).*sin(el0))));
            Gk  = Gpeak - 12*(ang./bwHalf).^2;
            G   = max(G, Gk);
        end
        Rn = max(G - min(G(:)), 0);
        Xp = Rn.*cos(EL).*cos(AZ);
        Yp = Rn.*cos(EL).*sin(AZ);
        Zp = Rn.*sin(EL);
        surf(ax, Xp, Yp, Zp, G, 'EdgeColor','none', 'FaceAlpha',0.88);
        colormap(ax, jet);
        cb = colorbar(ax);
        ylabel(cb,'Câștig (dBi)');
        cb.Color = [0.62 0.62 0.62];
        axis(ax,'equal');
        view(ax, [-35 25]);
    end
    xlabel(ax,'X','Color',[0.60 0.60 0.60]);
    ylabel(ax,'Y','Color',[0.60 0.60 0.60]);
    zlabel(ax,'Z','Color',[0.60 0.60 0.60]);
    grid(ax,'on');
    ax.Color     = [0.09 0.09 0.09];
    ax.XColor    = [0.60 0.60 0.60];
    ax.YColor    = [0.60 0.60 0.60];
    ax.ZColor    = [0.60 0.60 0.60];
    ax.GridColor = [0.32 0.32 0.32];
end

%  generateBeamDirections  -  Distributie Fibonacci pe sfera (N directii)

function dirs = generateBeamDirections(N)
    golden = (1 + sqrt(5)) / 2;
    i   = (0:N-1)';
    el  = asin(2*i/N - 1);
    az  = mod(2*pi*i/golden, 2*pi) - pi;
    dirs = [az, el];
end

%  getAntennaCharacteristics 
function lines = getAntennaCharacteristics(antennaType)
    if strcmp(antennaType, 'Izotropică')
        lines = { ...
            'Tip:         Antenă Izotropică', ...
            'Câștig:      0 dBi (uniform)', ...
            'Radiere:     Sferică, Toate Direcțiile', ...
            'Montaj:      [0, 0, 0] grade', ...
            'Frecvență:   1090 MHz (ADS-B)', ...
            'Putere TX:   125 W ', ...
            'Utilizare:   Model Simplificat'};
    else
        lines = { ...
            'Tip:         Phased Array 48 Fascicule', ...
            'Câștig max:  ~24 dBi / fascicul', ...
            'Fascicule:   48 spot beams', ...
            'Lățime fasc: ~8 grade (HPBW)', ...
            'Acoperire:   ~125 grade-conic', ...
            'Montare:     [0, -90, 0] grade', ...
            'Frecvență:   1090 MHz (ADS-B)', ...
            'Utilizare:   Model real Iridium NEXT'};
    end
end
