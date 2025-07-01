% function genresult_examplegainupdaterules()

load('inputdata_examplegainupdaterules.mat');

beta = @(x) 0.66*sin(x);
velavg = 3*movmean(max(velraw-10,0), 1000);
vf_thtilde = @(tsim, xsim) -beta(xsim(1)) + xsim(2)*interp1(2*t, deg2rad(velavg), tsim);

mu = 0.015;
kstar = 1.5;

th_tilde_0 = 0;
k_tilde_0 = 0.5;

tspan = [0, 1500];

savedir = '..\..\figures\model\example_gainupdaterules\raw';

figwidth = 6.75;
figheight = 0.64*6.75;
fontsize = 10;

%% rat trajectory
FigureSetup(figwidth, figheight);
% yyaxis left;
plot(2*t/60, velavg,'Linewidth',2,'Color',[0,0,0]);
xlim([0, max(tspan)/60]);
% ylabel('Velocity $v\;(^\circ/s)$', 'FontSize',fontsize, 'Interpreter','latex');
% xlabel('time (min)','FontSize', fontsize,'Interpreter','latex');
% set(gca,'XScale','log');
% yyaxis right;
% plot(tspan/60, kstar*ones(size(tspan)),'Linewidth',2);
% set(gca,'XScale','log');
% ylabel('Visual gain', 'FontSize', fontsize, 'Interpreter','latex');
% exportfig_to_savedir(fullfile(savedir,'animaltraj.pdf'));

%% example gain update rule 1
vf_ktilde_exp1 = @(tsim, xsim) -mu*xsim(1)*interp1(2*t, deg2rad(velavg), tsim);

vf_sim = @(tsim, xsim) [vf_thtilde(tsim, xsim); vf_ktilde_exp1(tsim, xsim)];

[tvec, xmat] = ode45(vf_sim, tspan, [th_tilde_0; k_tilde_0]);

FigureSetup(figwidth, figheight);
yyaxis left;
plot(tvec/60, rad2deg(xmat(:,1)), 'Linewidth', 2,'Color',[0,0,0]);
hold on;
% ylim([-5,30]);
xlim([0, max(tvec)/60]);
% set(gca,'XScale','log');
% ylabel('Positional error $\tilde{\theta}\;(^\circ)$', 'FontSize', fontsize, 'Interpreter','latex');
% xlabel('time (min)','FontSize', fontsize, 'Interpreter','latex');
yyaxis right;
plot(tvec/60, xmat(:,2), 'Linewidth', 2, 'Color', [0.4940 0.1840 0.5560]);
% ylim([-5,30]/60);
% set(gca,'XScale','log');
% ylabel('Gain error $\tilde{k}$', 'FontSize', fontsize, 'Interpreter','latex');
yyaxis left; ylim([-4, 17]);
yyaxis right; ylim([-4, 17]/28);
% yyaxis left;
% plot(tvec/60, zeros(size(tvec)), 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = [0.4940 0.1840 0.5560];
% exportfig_to_savedir(fullfile(savedir,'example1.pdf'));

velt = downsample(interp1(2*t, velavg, tvec),2);
gainerr = downsample(xmat(:,2),2);
poserr = downsample(rad2deg(xmat(:,1)),2);

FigureSetup(figwidth, figheight);
plot(gainerr, poserr, '.', 'Linewidth', 0.5,'Color',[0,0,0]);
hold on;
mdl = fitlm(gainerr, poserr);
xlim([-4, 17]/28); 
ylim([-4, 17]);
plot(gainerr, mdl.Fitted, 'r', 'LineWidth', 2.5);
set(gca,'YTick',[0,5,10,15],'XTick',[0,0.2,0.4,0.6]);
hl = legend('Data', sprintf('Fit ($R^2$=%d\\%%)', round(100*mdl.Rsquared.Ordinary)), 'Interpreter', 'latex', 'Location', 'best');
set(hl, 'FontSize', 9);

FigureSetup(figwidth, figheight);
plot(velt.*gainerr, poserr, '.', 'Linewidth', 0.5,'Color',[0,0,0]);
hold on;
mdl = fitlm(velt.*gainerr, poserr);
plot(velt.*gainerr, mdl.Fitted, 'r', 'LineWidth', 2.5);
xlim([-5.0000   11.1176]);
ylim([-4, 17]);
set(gca,'YTick',[0,5,10,15], 'XTick', [-5, 0, 5, 10]);
hl = legend('Data', sprintf('Fit ($R^2$=%d\\%%)', round(100*mdl.Rsquared.Ordinary)), 'Interpreter', 'latex', 'Location', 'best');
set(hl, 'FontSize', 9);



%% example gain update rule 2
vf_ktilde_exp2 = @(tsim, xsim) -mu*(0.12*(kstar-xsim(2))*interp1(2*t, deg2rad(velavg), tsim)^2 + xsim(1)*interp1(2*t, deg2rad(velavg), tsim));

vf_sim = @(tsim, xsim) [vf_thtilde(tsim, xsim); vf_ktilde_exp2(tsim, xsim)];

[tvec, xmat] = ode45(vf_sim, tspan, [th_tilde_0; k_tilde_0]);

FigureSetup(figwidth, figheight);
yyaxis left;
plot(tvec/60, rad2deg(xmat(:,1)), 'Linewidth', 2, 'Color', [0,0,0]);
hold on;
% ylim([-5,30]);
xlim([0, max(tvec)/60]);
% set(gca,'XScale','log');
% ylabel('Positional error $\tilde{\theta}\;(^\circ)$', 'FontSize', fontsize, 'Interpreter','latex');
% xlabel('time (min)','FontSize', fontsize,'Interpreter','latex');
yyaxis right;
plot(tvec/60, xmat(:,2), 'Linewidth', 2, 'Color', [0.4940 0.1840 0.5560]);
% ylim([-5,30]/60);
% set(gca,'XScale','log');
% ylabel('Gain error $\tilde{k}$', 'FontSize', fontsize, 'Interpreter','latex');
% yyaxis left;
% plot(tvec/60, zeros(size(tvec)), 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);
yyaxis left; ylim([-4, 17]);
yyaxis right; ylim([-4, 17]/28);
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = [0.4940 0.1840 0.5560];
% exportfig_to_savedir(fullfile(savedir,'example2.pdf'));

velt = downsample(interp1(2*t, velavg, tvec),2);
gainerr = downsample(xmat(:,2),2);
poserr = downsample(rad2deg(xmat(:,1)),2);

FigureSetup(figwidth, figheight);
plot(gainerr, poserr, '.', 'Linewidth', 0.5,'Color',[0,0,0]);
hold on;
mdl = fitlm(gainerr, poserr);
xlim([-4, 17]/28); 
ylim([-4, 17]);
plot(gainerr, mdl.Fitted, 'r', 'LineWidth', 2.5);
set(gca,'YTick',[0,5,10,15],'XTick',[0,0.2,0.4,0.6]);
hl = legend('Data', sprintf('Fit ($R^2$=%d\\%%)', round(100*mdl.Rsquared.Ordinary)), 'Interpreter', 'latex', 'Location', 'best');
set(hl, 'FontSize', 9);

FigureSetup(figwidth, figheight);
plot(velt.*gainerr, poserr, '.', 'Linewidth', 0.5,'Color',[0,0,0]);
hold on;
mdl = fitlm(velt.*gainerr, poserr);
plot(velt.*gainerr, mdl.Fitted, 'r', 'LineWidth', 2.5);
xlim([-5.0000   11.1176]);
ylim([-4, 17]);
set(gca,'YTick',[0,5,10,15], 'XTick', [-5, 0, 5, 10]);
hl = legend('Data', sprintf('Fit ($R^2$=%d\\%%)', round(100*mdl.Rsquared.Ordinary)), 'Interpreter', 'latex', 'Location', 'best');
set(hl, 'FontSize', 9);

%%
% end

function exportfig_to_savedir(filepath)
a = annotation('rectangle',[0 0 1 1],'Color','w');
exportgraphics(gcf,filepath,'ContentType','vector','BackgroundColor','none');
delete(a);
end

