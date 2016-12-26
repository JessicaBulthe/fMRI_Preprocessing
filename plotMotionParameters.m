% welk subject (enige aan te passen parameter)
Subject = 5;

% welke directory staat de data
Pathway = ['E:' filesep 'Research' filesep 'Correlatie Studie' filesep 'Preprocessing' filesep 'Subject' num2str(Subject) '' filesep 'scandata' filesep ''];

% inlezen van alle rp files
files = dir([Pathway 'rp_*.txt']);

% plotten van elke run
for i = 1:size(files,1)
    motpar = load([Pathway files(i).name]);
    figure(10)
    subplot(1,2,1)
    plot(motpar(:,1:3))
    subplot(1,2,2)
    plot(motpar(:,4:6))
    title(files(i).name);
    k = waitforbuttonpress; 
end

