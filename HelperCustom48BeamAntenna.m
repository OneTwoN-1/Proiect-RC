function antenna = HelperCustom48BeamAntenna(f_ADSB)
%% HELPERCUSTOM48BEAMANTENNA
% This function creates a composite beam that represents the combined 48 
% beams that make up the Iridium satellite primary antenna array. For more
% information and details on the construction of the Iridium antenna
% pattern and responses, refer to Attachment EngineeringStatement and
% Attachment Exhibit A in https://fcc.report/IBFS/SAT-MOD-20131227-00148.
%

% Beam Indices - 48 beams total
beamCountCenter = [15,32,31,48,47,16];
beamCountMiddle = [12,29,24,30,28,45,40,46,44,13,8,14];
beamCountOuter = [5,6,7,25,17,20,18,26,27,19,21,22,23,41,33,36,34,42,43,35,37,38,39,9,1,4,2,10,11,3];

% Pattern Geometry
radial_offset = [19,42,58]; % dge
radial_beamwidth = [35,15,20]; % deg
transverse_beamwidth = [21,30,12]; % deg

%% Beam Pattern

% Generate Beams
el = -90:1:90;
az = -90:1:90;

% Initialize beam pattern data
beamPat = zeros(numel(el),numel(az),48,'like',1);

%% Evaluate Each Beam in the Iridium Beam Array
for i = 1:48
 
    % Evaluate central beams
    if any(ismember(i,beamCountCenter))

        % Create gaussian antenna element with specified radial and
        % transverse beamwidths
        element = phased.GaussianAntennaElement( Beamwidth=[radial_beamwidth(1),transverse_beamwidth(1)]);

        % Generate beam pattern
        pat = zeros(numel(el),numel(az),'like',1);
        for m = 1:numel(el)
            temp = element(f_ADSB,[az;el(m)*ones(1,numel(az))]);
            pat(m,:) = temp;
        end

        % Rotate beam pattern to final position
        k = find(i == beamCountCenter);
        phi = 360/numel(beamCountCenter)*(k-1);
        newax = rotx(phi)*rotz(radial_offset(1));
        beamPat(:,:,i) = rotpat(pat,az,el,newax);        
    end

    % Evaluate middle beams
    if any(ismember(i,beamCountMiddle))

        % Create gaussian antenna element with specified radial and
        % transverse beamwidths
        element = phased.GaussianAntennaElement( Beamwidth=[radial_beamwidth(2),transverse_beamwidth(2)]);

        % Generate beam pattern
        pat = zeros(numel(el),numel(az),'like',1);
        for m = 1:numel(el)
            temp = element(f_ADSB,[az;el(m)*ones(1,numel(az))]);
            pat(m,:) = temp;
        end

        % Rotate beam pattern to final position
        k = find(i == beamCountMiddle);
        phi = 360/numel(beamCountMiddle)*(k-1);
        newax = rotx(phi)*rotz(radial_offset(2));
        beamPat(:,:,i) = rotpat(pat,az,el,newax);
    end

    % Evaluate outer beams
    if any(ismember(i,beamCountOuter))

        % Create gaussian antenna element with specified radial and
        % transverse beamwidths
        element = phased.GaussianAntennaElement( Beamwidth=[radial_beamwidth(3),transverse_beamwidth(3)]);

        % Generate beam pattern
        pat = zeros(numel(el),numel(az),'like',1);
        for m = 1:numel(el)
            temp = element(f_ADSB,[az;el(m)*ones(1,numel(az))]);
            pat(m,:) = temp;
        end

        % Rotate beam pattern to final position
        k = find(i == beamCountOuter);
        phi = 360/numel(beamCountOuter)*(k-1);
        newax = rotx(phi)*rotz(radial_offset(3));
        beamPat(:,:,i) = rotpat(pat,az,el,newax);
    end

end

%% Generate Composite Magnitude Pattern
% Select the highest beam magnitude.
compositeMag = max(abs(beamPat),[],3);


%% Custom Antenna Element
% Create and return the composite custom antenna element
antenna = phased.CustomAntennaElement(...
    'AzimuthAngles',az,...
    'ElevationAngles',el,...
    'MagnitudePattern',mag2db(compositeMag),...
    'PhasePattern',zeros(size(compositeMag)));

end