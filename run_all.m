function run_all
%RUN_ALL  Regenerate all figures for Faucher et al. (FeAl paper).
%   Runs each figure script and saves every figure it opens to ./figures
%   as PNG (300 dpi) and PDF. Requires MATLAB R2018b or later; no toolboxes.

here = fileparts(mfilename('fullpath'));
addpath(fullfile(here,'utils'));
outdir = fullfile(here,'figures');
if ~exist(outdir,'dir'), mkdir(outdir); end

scripts = {'figure2_costs_and_intensities'
           'figure3_abatement_costs'
           'figure4a_substitution_ratio'
           'figure4b_price_history'
           'figure4c_production_vs_electricity'
           'figure4d_emissions_and_pies'
           'figureS1_green_steel_premium'};

for s = 1:numel(scripts)
    name = scripts{s};
    fprintf('\n=== %s ===\n', name);
    close all
    feval(name);
    drawnow
    figs = findobj(0,'Type','figure');
    [~,order] = sort(arrayfun(@(f) double(get(f,'Number')), figs));
    figs = figs(order);
    for f = 1:numel(figs)
        base = fullfile(outdir, sprintf('%s_fig%d', name, get(figs(f),'Number')));
        savefig_compat(figs(f), [base '.png'], [base '.pdf']);
    end
    fprintf('  saved %d figure(s)\n', numel(figs));
end
close all
fprintf('\nDone. Figures are in %s\n', outdir);
end

function savefig_compat(fig, png, pdf)
if exist('exportgraphics','file')          % R2020a+
    exportgraphics(fig, png, 'Resolution', 300);
    exportgraphics(fig, pdf, 'ContentType', 'vector');
else                                       % R2018b-R2019b
    print(fig, png, '-dpng', '-r300');
    print(fig, pdf, '-dpdf', '-bestfit');
end
end
