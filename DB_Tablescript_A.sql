USE [SKSS]
GO
/****** Object:  Table [dbo].[__mm]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__mm](
	[line] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[__tmp]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__tmp](
	[data_received] [varchar](20) NULL,
	[N] [varchar](10) NULL,
	[disN] [int] NULL,
	[mintime] [bigint] NULL,
	[isbeta] [bit] NULL,
	[idd] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[_tracking]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_tracking](
	[par] [varchar](128) NULL,
	[val] [varchar](8000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AB__tableVolume]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AB__tableVolume](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[localtab] [varchar](256) NULL,
	[awsdb] [varchar](128) NULL,
	[awsevent] [varchar](128) NULL,
	[installcol] [varchar](128) NULL,
	[hasrows] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AB_Rows]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AB_Rows](
	[tab] [varchar](128) NULL,
	[n] [int] NULL,
	[distinctinstallid] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AB2RawAwsTables]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AB2RawAwsTables](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flight_id] [varchar](128) NULL,
	[Batch] [varchar](20) NULL,
	[awsTab] [varchar](128) NULL,
	[hasRows] [bigint] NULL,
	[rawQuery] [varchar](8000) NULL,
	[generatedTime] [datetime] NULL,
	[outputQuery] [varchar](8000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABAggBIBODetail]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABAggBIBODetail](
	[api_key] [varchar](128) NULL,
	[product_id] [varchar](128) NULL,
	[sk_tenure] [varchar](128) NULL,
	[os_name] [varchar](128) NULL,
	[manufacturer] [varchar](128) NULL,
	[os_version] [varchar](128) NULL,
	[screen_width] [varchar](128) NULL,
	[screen_height] [varchar](128) NULL,
	[locale] [varchar](128) NULL,
	[country_code] [varchar](128) NULL,
	[install_language] [varchar](128) NULL,
	[oem] [varchar](128) NULL,
	[b2b] [varchar](128) NULL,
	[metadata_appversion] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[subcategory] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[flight_constraint] [varchar](128) NULL,
	[onUTC] [varchar](128) NULL,
	[N] [varchar](128) NULL,
	[disN] [varchar](128) NULL,
	[runat] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABAggBIBODetailTracking]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABAggBIBODetailTracking](
	[api_key] [varchar](128) NULL,
	[product_id] [varchar](128) NULL,
	[sk_tenure] [varchar](128) NULL,
	[os_name] [varchar](128) NULL,
	[manufacturer] [varchar](128) NULL,
	[os_version] [varchar](128) NULL,
	[screen_width] [varchar](128) NULL,
	[screen_height] [varchar](128) NULL,
	[locale] [varchar](128) NULL,
	[country_code] [varchar](128) NULL,
	[install_language] [varchar](128) NULL,
	[oem] [varchar](128) NULL,
	[b2b] [varchar](128) NULL,
	[metadata_appversion] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[subcategory] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[flight_constraint] [varchar](128) NULL,
	[onUTC] [varchar](128) NULL,
	[fromN] [int] NULL,
	[fromDisN] [int] NULL,
	[toN] [int] NULL,
	[toDisN] [int] NULL,
	[runat] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABAggBIBOSum]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABAggBIBOSum](
	[metadata_appversion] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[subcategory] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[flight_constraint] [varchar](128) NULL,
	[onUTC] [varchar](128) NULL,
	[N] [varchar](128) NULL,
	[disN] [varchar](128) NULL,
	[runat] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABAggBIBOSumTracking]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABAggBIBOSumTracking](
	[metadata_appversion] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[subcategory] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[flight_constraint] [varchar](128) NULL,
	[onUTC] [varchar](128) NULL,
	[fromN] [int] NULL,
	[fromDisN] [int] NULL,
	[toN] [int] NULL,
	[toDisN] [int] NULL,
	[runat] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABAggLGCYDetailTracking]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABAggLGCYDetailTracking](
	[api_key] [varchar](128) NULL,
	[product_id] [varchar](128) NULL,
	[sk_tenure] [varchar](128) NULL,
	[os_name] [varchar](128) NULL,
	[manufacturer] [varchar](128) NULL,
	[os_version] [varchar](128) NULL,
	[screen_width] [varchar](128) NULL,
	[screen_height] [varchar](128) NULL,
	[locale] [varchar](128) NULL,
	[country_code] [varchar](128) NULL,
	[install_language] [varchar](128) NULL,
	[oem] [varchar](128) NULL,
	[b2b] [varchar](128) NULL,
	[experiment] [varchar](128) NULL,
	[expgroup] [varchar](128) NULL,
	[metadata_appversion] [varchar](128) NULL,
	[onUTC] [varchar](128) NULL,
	[fromN] [int] NULL,
	[fromDisN] [int] NULL,
	[toN] [int] NULL,
	[toDisN] [int] NULL,
	[runat] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABAggLGCYSum]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABAggLGCYSum](
	[experiment] [varchar](128) NULL,
	[expgroup] [varchar](128) NULL,
	[metadata_appversion] [varchar](128) NULL,
	[onUTC] [varchar](128) NULL,
	[N] [varchar](128) NULL,
	[disN] [varchar](128) NULL,
	[runat] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABAggLGCYSumTracking]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABAggLGCYSumTracking](
	[experiment] [varchar](128) NULL,
	[expgroup] [varchar](128) NULL,
	[metadata_appversion] [varchar](128) NULL,
	[onUTC] [date] NULL,
	[fromN] [int] NULL,
	[fromDisN] [int] NULL,
	[toN] [int] NULL,
	[toDisN] [int] NULL,
	[runat] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABBiboModelDownload]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABBiboModelDownload](
	[metadata_appversion] [varchar](20) NULL,
	[category] [varchar](20) NULL,
	[subcategory] [varchar](20) NULL,
	[flight_id] [varchar](50) NULL,
	[flight_constraint] [varchar](128) NULL,
	[onUTC] [varchar](50) NULL,
	[result] [varchar](20) NULL,
	[N] [int] NULL,
	[disN] [int] NULL,
	[lastupdated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABBiboModelDownloadStaging]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABBiboModelDownloadStaging](
	[metadata_appversion] [varchar](20) NULL,
	[category] [varchar](20) NULL,
	[subcategory] [varchar](20) NULL,
	[flight_id] [varchar](50) NULL,
	[flight_constraint] [varchar](8000) NULL,
	[onUTC] [varchar](50) NULL,
	[result] [varchar](20) NULL,
	[N] [varchar](20) NULL,
	[disN] [varchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABBiboModelEnable]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABBiboModelEnable](
	[metadata_appversion] [varchar](20) NULL,
	[category] [varchar](20) NULL,
	[subcategory] [varchar](20) NULL,
	[flight_id] [varchar](50) NULL,
	[flight_constraint] [varchar](128) NULL,
	[onUTC] [varchar](50) NULL,
	[N] [int] NULL,
	[disN] [int] NULL,
	[lastupdated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABBiboModelEnableStaging]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABBiboModelEnableStaging](
	[metadata_appversion] [varchar](20) NULL,
	[category] [varchar](20) NULL,
	[subcategory] [varchar](20) NULL,
	[flight_id] [varchar](50) NULL,
	[flight_constraint] [varchar](8000) NULL,
	[onUTC] [varchar](50) NULL,
	[N] [varchar](20) NULL,
	[disN] [varchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABBiboModelValidation]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABBiboModelValidation](
	[metadata_appversion] [varchar](20) NULL,
	[category] [varchar](20) NULL,
	[subcategory] [varchar](20) NULL,
	[flight_id] [varchar](50) NULL,
	[flight_constraint] [varchar](128) NULL,
	[onUTC] [varchar](50) NULL,
	[result] [varchar](20) NULL,
	[N] [int] NULL,
	[disN] [int] NULL,
	[lastupdated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABBiboModelValidationStaging]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABBiboModelValidationStaging](
	[metadata_appversion] [varchar](20) NULL,
	[category] [varchar](20) NULL,
	[subcategory] [varchar](20) NULL,
	[flight_id] [varchar](50) NULL,
	[flight_constraint] [varchar](8000) NULL,
	[onUTC] [varchar](50) NULL,
	[result] [varchar](20) NULL,
	[N] [varchar](20) NULL,
	[disN] [varchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABConfig]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABConfig](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[config] [varchar](128) NULL,
	[val] [varchar](1024) NULL,
	[notes] [varchar](8000) NULL,
	[addedon] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABDataExam]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABDataExam](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[UniqueCode] [varchar](128) NULL,
	[db] [varchar](20) NULL,
	[tab] [varchar](128) NULL,
	[localtab] [varchar](256) NULL,
	[datacategory] [varchar](50) NULL,
	[BIA] [varchar](20) NULL,
	[inGroup] [varchar](50) NULL,
	[hasRows] [int] NULL,
	[columnName] [varchar](128) NULL,
	[numVals] [int] NULL,
	[strVals] [int] NULL,
	[nullVals] [int] NULL,
	[distinctVals] [int] NULL,
	[strVal] [varchar](800) NULL,
	[strValN] [int] NULL,
	[strValRatio] [float] NULL,
	[strValRank] [int] NULL,
	[pairs] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABDatalog]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABDatalog](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[UniqueCode] [varchar](50) NULL,
	[flight_id] [varchar](50) NULL,
	[expname] [varchar](128) NULL,
	[appversion] [varchar](50) NULL,
	[apikey] [varchar](128) NULL,
	[db] [varchar](50) NULL,
	[tab] [varchar](128) NULL,
	[hasRows] [int] NULL,
	[minGroupRows] [int] NULL,
	[maxGroupRows] [int] NULL,
	[localTab] [varchar](128) NULL,
	[isExists] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABDataLogDetail]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABDataLogDetail](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[uniquecode] [varchar](20) NULL,
	[localtab] [varchar](128) NULL,
	[expgroup] [varchar](50) NULL,
	[position] [varchar](50) NULL,
	[N] [int] NULL,
	[distN] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABDataStaging]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABDataStaging](
	[metadata_installId] [varchar](2048) NULL,
	[metadata_appVersion] [varchar](2048) NULL,
	[metadata_timestamp_utcTimestamp] [varchar](2048) NULL,
	[metadata_timestamp_utcOffsetMins] [varchar](2048) NULL,
	[metadata_vectorClock_major] [varchar](2048) NULL,
	[metadata_vectorClock_minor] [varchar](2048) NULL,
	[metadata_vectorClock_order] [varchar](2048) NULL,
	[application] [varchar](2048) NULL,
	[durationMillis] [varchar](2048) NULL,
	[typingStats_totalTokensEntered] [varchar](2048) NULL,
	[typingStats_tokensFlowed] [varchar](2048) NULL,
	[typingStats_tokensPredicted] [varchar](2048) NULL,
	[typingStats_tokensCorrected] [varchar](2048) NULL,
	[typingStats_tokensVerbatim] [varchar](2048) NULL,
	[typingStats_tokensPartial] [varchar](2048) NULL,
	[typingStats_netCharsEntered] [varchar](2048) NULL,
	[typingStats_deletions] [varchar](2048) NULL,
	[typingStats_characterKeystrokes] [varchar](2048) NULL,
	[typingStats_predictionKeystrokes] [varchar](2048) NULL,
	[typingStats_remainderKeystrokes] [varchar](2048) NULL,
	[typingStats_predictionSumLength] [varchar](2048) NULL,
	[typingStats_typingDurationMillis] [varchar](2048) NULL,
	[typingStats_emojisEntered] [varchar](2048) NULL,
	[languagesUsed] [varchar](2048) NULL,
	[termsPerLanguage] [varchar](2048) NULL,
	[userHandle] [varchar](2048) NULL,
	[typingStats_totalTokensEnteredEdited] [varchar](2048) NULL,
	[typingStats_tokensFlowedEdited] [varchar](2048) NULL,
	[typingStats_tokensPredictedEdited] [varchar](2048) NULL,
	[typingStats_tokensCorrectedEdited] [varchar](2048) NULL,
	[typingStats_tokensVerbatimEdited] [varchar](2048) NULL,
	[typingStats_tokensPartialEdited] [varchar](2048) NULL,
	[tokensPerSource] [varchar](2048) NULL,
	[tokensShownPerSource] [varchar](2048) NULL,
	[date_received] [varchar](2048) NULL,
	[last_merge] [varchar](2048) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABDataTable]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABDataTable](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[db] [varchar](128) NULL,
	[tab] [varchar](128) NULL,
	[installidcol] [varchar](128) NULL,
	[isTemp] [varchar](20) NULL,
	[isUsed] [bit] NULL,
	[chopby] [int] NULL,
	[timestampcol] [varchar](50) NULL,
	[lastscaned] [datetime] NULL,
	[lastsize] [int] NULL,
	[scansequence] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABDataTableStaging]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABDataTableStaging](
	[tab] [varchar](128) NULL,
	[isTemp] [varchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExpEnablementScanLog]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExpEnablementScanLog](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[scantype] [varchar](20) NULL,
	[isenabled] [bit] NULL,
	[lastdate] [varchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperiment]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperiment](
	[api_key] [varchar](128) NULL,
	[app_version] [varchar](128) NULL,
	[TYPE] [varchar](128) NULL,
	[experiment] [varchar](128) NULL,
	[experiment_group] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[sub_category] [varchar](128) NULL,
	[variant] [varchar](128) NULL,
	[blob_owner] [varchar](128) NULL,
	[flight_start_time] [datetime] NULL,
	[flight_end_time] [datetime] NULL,
	[start_timestamp] [datetime] NULL,
	[end_timestamp] [datetime] NULL,
	[completed] [varchar](50) NULL,
	[disN] [int] NULL,
	[N] [int] NULL,
	[reformulated_experiment_group] [varchar](128) NULL,
	[uniquecode] [varchar](128) NULL,
	[lastupdated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperimentBiboStartTimeStampVolume]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperimentBiboStartTimeStampVolume](
	[api_key] [varchar](128) NULL,
	[app_version] [varchar](128) NULL,
	[TYPE] [varchar](128) NULL,
	[experiment] [varchar](128) NULL,
	[experiment_group] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[sub_category] [varchar](128) NULL,
	[variant] [varchar](128) NULL,
	[blob_owner] [varchar](128) NULL,
	[flight_start_time] [datetime] NULL,
	[flight_end_time] [datetime] NULL,
	[start_timestamp] [datetime] NULL,
	[end_timestamp] [datetime] NULL,
	[completed] [varchar](50) NULL,
	[disN] [int] NULL,
	[N] [int] NULL,
	[reformulated_experiment_group] [varchar](128) NULL,
	[uniquecode] [varchar](128) NULL,
	[lastupdated] [datetime] NULL,
	[nominatedDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperimentBiboVolume]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperimentBiboVolume](
	[api_key] [varchar](128) NULL,
	[app_version] [varchar](128) NULL,
	[TYPE] [varchar](128) NULL,
	[experiment] [varchar](128) NULL,
	[experiment_group] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[sub_category] [varchar](128) NULL,
	[variant] [varchar](128) NULL,
	[blob_owner] [varchar](128) NULL,
	[flight_start_time] [datetime] NULL,
	[flight_end_time] [datetime] NULL,
	[start_timestamp] [datetime] NULL,
	[end_timestamp] [datetime] NULL,
	[completed] [varchar](50) NULL,
	[disN] [int] NULL,
	[N] [int] NULL,
	[reformulated_experiment_group] [varchar](128) NULL,
	[uniquecode] [varchar](128) NULL,
	[lastupdated] [datetime] NULL,
	[nominatedDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperimentDate]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperimentDate](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[experiment] [varchar](128) NULL,
	[majorversion] [varchar](20) NULL,
	[disN] [int] NULL,
	[samplingperiod] [int] NULL,
	[fromutc] [date] NULL,
	[toutc] [date] NULL,
	[updatedon] [datetime] NULL,
	[overallN] [int] NULL,
	[needReprocess] [bit] NULL,
	[uniquecode] [varchar](50) NULL,
	[outputfile] [varchar](1024) NULL,
	[exptype] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperimentLegacyVolume]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperimentLegacyVolume](
	[api_key] [varchar](128) NULL,
	[app_version] [varchar](128) NULL,
	[TYPE] [varchar](128) NULL,
	[experiment] [varchar](128) NULL,
	[experiment_group] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[sub_category] [varchar](128) NULL,
	[variant] [varchar](128) NULL,
	[blob_owner] [varchar](128) NULL,
	[flight_start_time] [datetime] NULL,
	[flight_end_time] [datetime] NULL,
	[start_timestamp] [datetime] NULL,
	[end_timestamp] [datetime] NULL,
	[completed] [varchar](50) NULL,
	[disN] [int] NULL,
	[N] [int] NULL,
	[reformulated_experiment_group] [varchar](128) NULL,
	[uniquecode] [varchar](128) NULL,
	[lastupdated] [datetime] NULL,
	[nominatedDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperimentLegacyVolumeBackup]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperimentLegacyVolumeBackup](
	[api_key] [varchar](128) NULL,
	[app_version] [varchar](128) NULL,
	[TYPE] [varchar](128) NULL,
	[experiment] [varchar](128) NULL,
	[experiment_group] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[sub_category] [varchar](128) NULL,
	[variant] [varchar](128) NULL,
	[blob_owner] [varchar](128) NULL,
	[flight_start_time] [datetime] NULL,
	[flight_end_time] [datetime] NULL,
	[start_timestamp] [datetime] NULL,
	[end_timestamp] [datetime] NULL,
	[completed] [varchar](50) NULL,
	[disN] [int] NULL,
	[N] [int] NULL,
	[reformulated_experiment_group] [varchar](128) NULL,
	[uniquecode] [varchar](128) NULL,
	[lastupdated] [datetime] NULL,
	[nominatedDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperimentLegacyVolumeSep5]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperimentLegacyVolumeSep5](
	[api_key] [varchar](128) NULL,
	[app_version] [varchar](128) NULL,
	[TYPE] [varchar](128) NULL,
	[experiment] [varchar](128) NULL,
	[experiment_group] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[sub_category] [varchar](128) NULL,
	[variant] [varchar](128) NULL,
	[blob_owner] [varchar](128) NULL,
	[flight_start_time] [datetime] NULL,
	[flight_end_time] [datetime] NULL,
	[start_timestamp] [datetime] NULL,
	[end_timestamp] [datetime] NULL,
	[completed] [varchar](50) NULL,
	[disN] [int] NULL,
	[N] [int] NULL,
	[reformulated_experiment_group] [varchar](128) NULL,
	[uniquecode] [varchar](128) NULL,
	[lastupdated] [datetime] NULL,
	[nominatedDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperimentQuota]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperimentQuota](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[uniquecode] [varchar](20) NULL,
	[flight_id] [varchar](50) NULL,
	[inferredexpname] [varchar](128) NULL,
	[expstatus] [varchar](128) NULL,
	[expgroup] [varchar](128) NULL,
	[gp] [varchar](128) NULL,
	[exptype] [varchar](20) NULL,
	[appver] [varchar](40) NULL,
	[appvermajor] [varchar](40) NULL,
	[n] [int] NULL,
	[quota] [int] NULL,
	[fromUtc] [date] NULL,
	[toUtc] [date] NULL,
	[lastupdated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABExperimentStaging]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABExperimentStaging](
	[api_key] [varchar](128) NULL,
	[app_version] [varchar](128) NULL,
	[TYPE] [varchar](128) NULL,
	[experiment] [varchar](128) NULL,
	[experiment_group] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[sub_category] [varchar](128) NULL,
	[variant] [varchar](128) NULL,
	[blob_owner] [varchar](128) NULL,
	[flight_start_time] [varchar](128) NULL,
	[flight_end_time] [varchar](128) NULL,
	[start_timestamp] [varchar](128) NULL,
	[end_timestamp] [varchar](128) NULL,
	[completed] [varchar](128) NULL,
	[disN] [varchar](128) NULL,
	[N] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABgTestData]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABgTestData](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[val] [varchar](128) NULL,
	[N] [int] NULL,
	[scope] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABGTestDataOriginal]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABGTestDataOriginal](
	[grp] [varchar](128) NULL,
	[BIA] [varchar](128) NULL,
	[rn] [int] NULL,
	[val] [varchar](128) NULL,
	[N] [int] NULL,
	[UnWeightedN] [int] NULL,
	[GroupN] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABGTestResultPool]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABGTestResultPool](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[col] [varchar](128) NULL,
	[localtab] [varchar](128) NULL,
	[val1] [varchar](128) NULL,
	[val2] [varchar](128) NULL,
	[AinVal1] [int] NULL,
	[AinVal2] [int] NULL,
	[AinTotal] [int] NULL,
	[AbeforeVal1] [int] NULL,
	[AbeforeVal2] [int] NULL,
	[AbeforeTotal] [int] NULL,
	[BinVal1] [int] NULL,
	[BinVal2] [int] NULL,
	[BinTotal] [int] NULL,
	[BbeforeVal1] [int] NULL,
	[BbeforeVal2] [int] NULL,
	[BbeforeTotal] [int] NULL,
	[Ain_Abefore] [float] NULL,
	[Bbefore_Abefore] [float] NULL,
	[Bbefore_Ain] [float] NULL,
	[Bin_Abefore] [float] NULL,
	[Bin_Ain] [float] NULL,
	[Bin_Bbefore] [float] NULL,
	[testNotes] [varchar](4000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABHolder]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABHolder](
	[av] [float] NULL,
	[dev] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABInspectionList]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABInspectionList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Attribute] [varchar](128) NULL,
	[LocalTab] [varchar](128) NULL,
	[Database/EventName] [varchar](128) NULL,
	[DataTable] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABJoinExp]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABJoinExp](
	[onUTC] [varchar](128) NULL,
	[N] [int] NULL,
	[disN] [int] NULL,
	[experiment] [varchar](256) NULL,
	[expgroup] [varchar](2048) NULL,
	[metadata_appVersion] [varchar](128) NULL,
	[lastUpdated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABJoinExpStaging]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABJoinExpStaging](
	[onUTC] [varchar](128) NULL,
	[N] [varchar](20) NULL,
	[disN] [varchar](20) NULL,
	[experiment] [varchar](max) NULL,
	[expgroup] [varchar](2048) NULL,
	[metadata_appVersion] [varchar](128) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABpairedData]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABpairedData](
	[x] [float] NULL,
	[y] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABPlot]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABPlot](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[experiment] [varchar](256) NULL,
	[attributeName] [varchar](18) NULL,
	[localtab] [varchar](128) NULL,
	[plot] [varbinary](max) NULL,
	[generatedtime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABPlotData]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABPlotData](
	[measure] [float] NULL,
	[Grp] [varchar](50) NULL,
	[BIA] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABPreAnalysis]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABPreAnalysis](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[col] [varchar](128) NULL,
	[localTab] [varchar](128) NULL,
	[Atop1] [int] NULL,
	[Atop2] [int] NULL,
	[Arest] [int] NULL,
	[Btop1] [int] NULL,
	[Btop2] [int] NULL,
	[Brest] [int] NULL,
	[AinTop1] [int] NULL,
	[AinTop2] [int] NULL,
	[AinRest] [int] NULL,
	[BinTop1] [int] NULL,
	[BinTop2] [int] NULL,
	[BinRest] [int] NULL,
	[AbeforeTop1] [int] NULL,
	[AbeforeTop2] [int] NULL,
	[AbeforeRest] [int] NULL,
	[BbeforeTop1] [int] NULL,
	[BbeforeTop2] [int] NULL,
	[BbeforeRest] [int] NULL,
	[AafterTop1] [int] NULL,
	[AafterTop2] [int] NULL,
	[AafterRest] [int] NULL,
	[BafterTop1] [int] NULL,
	[BafterTop2] [int] NULL,
	[BafterRest] [int] NULL,
	[numvalues] [int] NULL,
	[catvalues] [int] NULL,
	[distinctValues] [int] NULL,
	[AdistinctN] [int] NULL,
	[BdistinctN] [int] NULL,
	[AinN] [int] NULL,
	[BinN] [int] NULL,
	[AbeforeN] [int] NULL,
	[BbeforeN] [int] NULL,
	[AafterN] [int] NULL,
	[BafterN] [int] NULL,
	[AinAvg] [float] NULL,
	[AinVar] [float] NULL,
	[BinAvg] [float] NULL,
	[BinVar] [float] NULL,
	[AbeforeAvg] [float] NULL,
	[AbeforeVar] [float] NULL,
	[BbeforeAvg] [float] NULL,
	[BbeforeVar] [float] NULL,
	[AafterAvg] [float] NULL,
	[AafterVar] [float] NULL,
	[BafterAvg] [float] NULL,
	[BafterVar] [float] NULL,
	[top1val] [varchar](1024) NULL,
	[top2val] [varchar](1024) NULL,
	[featureType] [varchar](50) NULL,
	[testType] [varchar](30) NULL,
	[filterType] [varchar](50) NULL,
	[notes] [varchar](8000) NULL,
	[excluded] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABProfilee4fc8f7c_6d59_11e7_9965_0694a5dc57b2]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABProfilee4fc8f7c_6d59_11e7_9965_0694a5dc57b2](
	[install_id] [varchar](8000) NULL,
	[category] [varchar](8000) NULL,
	[sub_category] [varchar](8000) NULL,
	[variant] [varchar](8000) NULL,
	[experiment_group] [varchar](8000) NULL,
	[flight_start_time] [varchar](8000) NULL,
	[flight_end_time] [varchar](8000) NULL,
	[start_timestamp] [varchar](8000) NULL,
	[end_timestamp] [varchar](8000) NULL,
	[lifetime_versions] [varchar](8000) NULL,
	[product_version_full] [varchar](8000) NULL,
	[last_log_received_timestamp] [varchar](8000) NULL,
	[sk_tenure] [varchar](8000) NULL,
	[screen_width] [varchar](8000) NULL,
	[screen_height] [varchar](8000) NULL,
	[locale] [varchar](8000) NULL,
	[language_config] [varchar](8000) NULL,
	[country_code] [varchar](8000) NULL,
	[last_device_id] [varchar](8000) NULL,
	[b2b] [varchar](8000) NULL,
	[sk_tenure_group] [varchar](8000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABQueryLog]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABQueryLog](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[UniqueCode] [varchar](50) NULL,
	[db] [varchar](50) NULL,
	[tab] [varchar](128) NULL,
	[fetchquery] [varchar](8000) NULL,
	[executed] [datetime] NULL,
	[outputFile] [varchar](1024) NULL,
	[injected] [datetime] NULL,
	[hasFileError] [bit] NULL,
	[isChopped] [bit] NULL,
	[filtered] [bit] NULL,
	[examedbitwise] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABResult_g]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABResult_g](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[attributeName] [varchar](128) NULL,
	[localtab] [varchar](128) NULL,
	[featuretype] [varchar](20) NULL,
	[testtype] [varchar](128) NULL,
	[val] [varchar](128) NULL,
	[overalValN] [int] NULL,
	[valRatioToAll] [float] NULL,
	[overalValRN] [int] NULL,
	[compareBIA] [varchar](50) NULL,
	[compareInGroup] [varchar](50) NULL,
	[compareStrN] [int] NULL,
	[compareRestN] [int] NULL,
	[comparedBIA] [varchar](50) NULL,
	[comparedInGroup] [varchar](50) NULL,
	[comparedStrN] [int] NULL,
	[comparedRestN] [int] NULL,
	[p_value] [float] NULL,
	[testTime] [datetime] NULL,
	[info] [varchar](256) NULL,
	[isMakeSense] [int] NULL,
	[Experiment] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABResult_paired]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABResult_paired](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[attributeName] [varchar](128) NULL,
	[localtab] [varchar](128) NULL,
	[featuretype] [varchar](20) NULL,
	[testtype] [varchar](128) NULL,
	[info] [varchar](128) NULL,
	[t] [varchar](128) NULL,
	[p_value] [float] NULL,
	[conf_f] [varchar](128) NULL,
	[conf_t] [varchar](128) NULL,
	[mean1] [varchar](128) NULL,
	[mean2] [varchar](128) NULL,
	[method] [varchar](128) NULL,
	[parameter] [varchar](128) NULL,
	[null_value] [varchar](128) NULL,
	[alternative] [varchar](128) NULL,
	[dataname] [varchar](128) NULL,
	[testTime] [datetime] NULL,
	[compareBIA] [varchar](50) NULL,
	[compareInGroup] [varchar](50) NULL,
	[compareNumVals] [int] NULL,
	[compareStrVals] [int] NULL,
	[compareNullVals] [int] NULL,
	[copmaredistinctVals] [int] NULL,
	[comparedBIA] [varchar](50) NULL,
	[comparedInGroup] [varchar](50) NULL,
	[comparedNumVals] [int] NULL,
	[comparedStrVals] [int] NULL,
	[comparedNullVals] [int] NULL,
	[copmareddistinctVals] [int] NULL,
	[pairs] [int] NULL,
	[isMakeSense] [int] NULL,
	[Experiment] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABResult_t]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABResult_t](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[attributeName] [varchar](128) NULL,
	[localtab] [varchar](128) NULL,
	[featuretype] [varchar](20) NULL,
	[testtype] [varchar](128) NULL,
	[info] [varchar](128) NULL,
	[t] [varchar](128) NULL,
	[p_value] [float] NULL,
	[conf_f] [varchar](128) NULL,
	[conf_t] [varchar](128) NULL,
	[mean1] [varchar](128) NULL,
	[mean2] [varchar](128) NULL,
	[method] [varchar](128) NULL,
	[parameter] [varchar](128) NULL,
	[null_value] [varchar](128) NULL,
	[alternative] [varchar](128) NULL,
	[dataname] [varchar](128) NULL,
	[testTime] [datetime] NULL,
	[compareBIA] [varchar](50) NULL,
	[compareInGroup] [varchar](50) NULL,
	[compareNumVals] [int] NULL,
	[compareStrVals] [int] NULL,
	[compareNullVals] [int] NULL,
	[copmaredistinctVals] [int] NULL,
	[comparedBIA] [varchar](50) NULL,
	[comparedInGroup] [varchar](50) NULL,
	[comparedNumVals] [int] NULL,
	[comparedStrVals] [int] NULL,
	[comparedNullVals] [int] NULL,
	[copmareddistinctVals] [int] NULL,
	[isMakeSense] [int] NULL,
	[experiment] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABResultPool]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABResultPool](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[col] [varchar](128) NULL,
	[localtab] [varchar](128) NULL,
	[featuretype] [varchar](20) NULL,
	[testtype] [varchar](128) NULL,
	[compare] [varchar](128) NULL,
	[info] [varchar](128) NULL,
	[t] [varchar](128) NULL,
	[p_value] [varchar](128) NULL,
	[conf_f] [varchar](128) NULL,
	[conf_t] [varchar](128) NULL,
	[mean1] [varchar](128) NULL,
	[mean2] [varchar](128) NULL,
	[method] [varchar](128) NULL,
	[parameter] [varchar](128) NULL,
	[null_value] [varchar](128) NULL,
	[alternative] [varchar](128) NULL,
	[dataname] [varchar](128) NULL,
	[testTime] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABResults]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABResults](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[dataId] [int] NULL,
	[StatTest] [varchar](128) NULL,
	[Info] [varchar](max) NULL,
	[Ain_Abefore] [float] NULL,
	[Bbefore_Abefore] [float] NULL,
	[Bbefore_Ain] [float] NULL,
	[Bin_Abefore] [float] NULL,
	[Bin_Ain] [float] NULL,
	[Bin_Bbefore] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABSampleInstallIdStaging]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABSampleInstallIdStaging](
	[metaday] [varchar](512) NULL,
	[inn] [varchar](512) NULL,
	[app_appversionmajor] [varchar](512) NULL,
	[metadata_installid] [varchar](512) NULL,
	[experiment] [varchar](512) NULL,
	[expgroup] [varchar](512) NULL,
	[metadata_appversion] [varchar](512) NULL,
	[manufacturer] [varchar](512) NULL,
	[model] [varchar](512) NULL,
	[os_version] [varchar](512) NULL,
	[screen_width] [varchar](512) NULL,
	[screen_height] [varchar](512) NULL,
	[locale] [varchar](512) NULL,
	[country_name] [varchar](512) NULL,
	[oem] [varchar](512) NULL,
	[b2b] [varchar](512) NULL,
	[sk_tenure_group] [varchar](512) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABSampleLog]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABSampleLog](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[UniqueCode] [varchar](12) NULL,
	[flight_id] [varchar](128) NULL,
	[querygenerated] [datetime] NULL,
	[dataQuery] [varchar](max) NULL,
	[exptype] [varchar](20) NULL,
	[awssampletab] [varchar](128) NULL,
	[awssamplequery] [varchar](8000) NULL,
	[outputfilename] [varchar](8000) NULL,
	[outputquery] [varchar](8000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABTableCandidate]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABTableCandidate](
	[idd] [int] NULL,
	[localTab] [varchar](128) NULL,
	[awsDB] [varchar](128) NULL,
	[awsTab] [varchar](128) NULL,
	[datarows] [int] NULL,
	[isWant] [bit] NULL,
	[firstIdentified] [datetime] NULL,
	[hasIn] [varchar](1024) NULL,
	[hasBefore] [varchar](1024) NULL,
	[hasAfter] [varchar](1024) NULL,
	[rn] [int] NULL,
	[installIdCol] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABTableVolume]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABTableVolume](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[awsDB] [varchar](128) NULL,
	[awsTab] [varchar](128) NULL,
	[inTab] [varchar](128) NULL,
	[beforeTab] [varchar](128) NULL,
	[afterTab] [varchar](128) NULL,
	[rootTab] [varchar](128) NULL,
	[inTabRows] [int] NULL,
	[beforeTabRows] [int] NULL,
	[afterTabRows] [int] NULL,
	[rootTabRows] [int] NULL,
	[installIdCol] [varchar](128) NULL,
	[Gathered] [bit] NULL,
	[BIAupdated] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABTest]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABTest](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[testtype] [varchar](20) NULL,
	[uniquecode] [varchar](50) NULL,
	[experiment] [varchar](128) NULL,
	[majorversion] [varchar](50) NULL,
	[samplefrom] [date] NULL,
	[sampleto] [date] NULL,
	[datafromdate] [date] NULL,
	[datatodate] [date] NULL,
	[periodDisN] [int] NULL,
	[expgroups] [int] NULL,
	[samplesize] [int] NULL,
	[expstatus] [varchar](20) NULL,
	[username] [varchar](128) NULL,
	[generatedon] [datetime] NULL,
	[exptype] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABTestData]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABTestData](
	[measure] [float] NULL,
	[Cate] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABTestData2]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABTestData2](
	[measure] [float] NULL,
	[Cate] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABTestSamplingQuery]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABTestSamplingQuery](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[uniquecode] [varchar](50) NULL,
	[runsequence] [int] NULL,
	[query] [varchar](max) NULL,
	[querycategory] [varchar](50) NULL,
	[generatedby] [varchar](50) NULL,
	[generatedon] [datetime] NULL,
	[lastupdatedon] [datetime] NULL,
	[DB] [varchar](128) NULL,
	[eventname] [varchar](128) NULL,
	[localtab] [varchar](1024) NULL,
	[localfilename] [varchar](1024) NULL,
	[installcol] [varchar](128) NULL,
	[timestampcol] [varchar](128) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABTmp]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABTmp](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[par] [varchar](128) NULL,
	[val] [varchar](8000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ABtTestData]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ABtTestData](
	[measure] [float] NULL,
	[Cate] [varchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aggregates__experiments]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aggregates__experiments](
	[install_id] [varchar](8000) NULL,
	[flight_start_time] [varchar](8000) NULL,
	[flight_end_time] [varchar](8000) NULL,
	[start_timestamp] [varchar](8000) NULL,
	[end_timestamp] [varchar](8000) NULL,
	[start_vcmaj] [varchar](8000) NULL,
	[start_vcmin] [varchar](8000) NULL,
	[end_vcmaj] [varchar](8000) NULL,
	[end_vcmin] [varchar](8000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[aggTmp]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aggTmp](
	[api_key] [varchar](128) NULL,
	[product_id] [varchar](128) NULL,
	[sk_tenure] [varchar](128) NULL,
	[os_name] [varchar](128) NULL,
	[manufacturer] [varchar](128) NULL,
	[os_version] [varchar](128) NULL,
	[screen_width] [varchar](128) NULL,
	[screen_height] [varchar](128) NULL,
	[locale] [varchar](128) NULL,
	[country_code] [varchar](128) NULL,
	[install_language] [varchar](128) NULL,
	[oem] [varchar](128) NULL,
	[b2b] [varchar](128) NULL,
	[metadata_appversion] [varchar](128) NULL,
	[category] [varchar](128) NULL,
	[subcategory] [varchar](128) NULL,
	[flight_id] [varchar](128) NULL,
	[flight_constraint] [varchar](8000) NULL,
	[onUTC] [varchar](128) NULL,
	[N] [varchar](128) NULL,
	[disN] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlertAlert]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlertAlert](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[changeType] [varchar](20) NULL,
	[db] [varchar](128) NULL,
	[eventname] [varchar](128) NULL,
	[attributename] [varchar](128) NULL,
	[fromValue] [varchar](128) NULL,
	[tovalue] [varchar](128) NULL,
	[fromaddedon] [varchar](20) NULL,
	[toaddedon] [varchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlertFunctions]    Script Date: 9/19/2017 2:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlertFunctions](
	[idfunction] [int] NOT NULL,
	[functionname] [varchar](128) NULL,
	[subscribers] [int] NULL,
	[alerts] [int] NULL,
	[addedOn] [datetime] NULL,
	[querypar] [varchar](128) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[idfunction] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlertLog]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlertLog](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[db] [varchar](128) NULL,
	[addedon] [varchar](20) NULL,
	[previousaddedon] [varchar](20) NULL,
	[subscriber] [varchar](128) NULL,
	[emailed] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlertSubscription]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlertSubscription](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[idfunction] [int] NULL,
	[subscriber] [varchar](128) NULL,
	[email] [varchar](128) NULL,
	[OnOff] [int] NULL,
	[lastupdated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBaggregates]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBaggregates](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_2017072921] [varchar](128) NULL,
	[See_2017072921SampleValue] [varchar](512) NULL,
	[See_2017081721] [varchar](128) NULL,
	[See_2017081721_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBAndroid]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBAndroid](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_2017072921] [varchar](128) NULL,
	[See_2017072921SampleValue] [varchar](512) NULL,
	[See_2017081721] [varchar](128) NULL,
	[See_2017081721_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBcloud_telemetry]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBcloud_telemetry](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_20170911] [varchar](128) NULL,
	[See_20170911SampleValue] [varchar](512) NULL,
	[See_20170915] [varchar](128) NULL,
	[See_20170915_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBdossier_beta_test]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBdossier_beta_test](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_20170911] [varchar](128) NULL,
	[See_20170911SampleValue] [varchar](512) NULL,
	[See_20170915] [varchar](128) NULL,
	[See_20170915_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBsk_android]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBsk_android](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_20170911] [varchar](128) NULL,
	[See_20170911SampleValue] [varchar](512) NULL,
	[See_20170915] [varchar](128) NULL,
	[See_20170915_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBskandroid]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBskandroid](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_2017072921] [varchar](128) NULL,
	[See_2017072921SampleValue] [varchar](512) NULL,
	[See_2017081721] [varchar](128) NULL,
	[See_2017081721_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBskandroid_beta]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBskandroid_beta](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_2017072921] [varchar](128) NULL,
	[See_2017072921SampleValue] [varchar](512) NULL,
	[See_2017081721] [varchar](128) NULL,
	[See_2017081721_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBskandroid_emoji]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBskandroid_emoji](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_2017072921] [varchar](128) NULL,
	[See_2017072921SampleValue] [varchar](512) NULL,
	[See_2017081721] [varchar](128) NULL,
	[See_2017081721_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBskios]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBskios](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_2017072921] [varchar](128) NULL,
	[See_2017072921SampleValue] [varchar](512) NULL,
	[See_2017081721] [varchar](128) NULL,
	[See_2017081721_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AlterDBskios_beta]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlterDBskios_beta](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[flag] [int] NULL,
	[DatabaseName] [varchar](128) NULL,
	[EventName] [varchar](128) NULL,
	[AttributeName] [varchar](128) NULL,
	[See_2017072921] [varchar](128) NULL,
	[See_2017072921SampleValue] [varchar](512) NULL,
	[See_2017081721] [varchar](128) NULL,
	[See_2017081721_sampleValue] [varchar](512) NULL,
	[rn] [int] NULL,
	[rn2] [int] NULL,
	[color] [varchar](50) NULL,
	[theURL] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InstallationId_EXP62c8a2e1_5d85_11e7_b929_069301d06e0a]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstallationId_EXP62c8a2e1_5d85_11e7_b929_069301d06e0a](
	[install_id] [varchar](234) NULL,
	[category] [varchar](234) NULL,
	[sub_category] [varchar](234) NULL,
	[variant] [varchar](234) NULL,
	[experiment_group] [varchar](234) NULL,
	[lifetime_versions] [varchar](234) NULL,
	[product_version_full] [varchar](234) NULL,
	[last_log_received_timestamp] [varchar](234) NULL,
	[sk_tenure] [varchar](234) NULL,
	[screen_width] [varchar](234) NULL,
	[screen_height] [varchar](234) NULL,
	[locale] [varchar](234) NULL,
	[language_config] [varchar](234) NULL,
	[country_code] [varchar](234) NULL,
	[last_device_id] [varchar](234) NULL,
	[b2b] [varchar](234) NULL,
	[sk_tenure_group] [varchar](234) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRContentChange]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRContentChange](
	[db] [varchar](50) NULL,
	[eventName] [varchar](128) NULL,
	[attributeName] [varchar](128) NULL,
	[See_20170911] [varchar](128) NULL,
	[See_20170911_sampleVaue] [varchar](512) NULL,
	[See_20170915] [varchar](128) NULL,
	[See_20170915_sampleVaue] [varchar](512) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRDB]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRDB](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[db] [varchar](128) NULL,
	[checkedon] [varchar](20) NULL,
	[script] [varchar](2048) NULL,
	[isrun] [bit] NULL,
	[dbfile] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRInspection]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRInspection](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[addedon] [varchar](20) NULL,
	[addedby] [varchar](50) NULL,
	[flowstatus] [varchar](128) NULL,
	[addedtime] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRQueryStaging]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRQueryStaging](
	[db] [varchar](128) NULL,
	[tab] [varchar](128) NULL,
	[thefile] [varchar](256) NULL,
	[query] [varchar](4000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRschema]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRschema](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[tab] [varchar](128) NULL,
	[seq] [int] NULL,
	[col] [varchar](128) NULL,
	[samplevalue] [varchar](1024) NULL,
	[addedon] [varchar](30) NULL,
	[db] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRSchemaChange]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRSchemaChange](
	[db] [varchar](50) NULL,
	[eventName] [varchar](128) NULL,
	[See_20170911] [varchar](32) NULL,
	[See_20170915] [varchar](32) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRSchemaException]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRSchemaException](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[db] [varchar](128) NULL,
	[tab] [varchar](128) NULL,
	[addedon] [varchar](128) NULL,
	[reason] [varchar](1024) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRSchemaStaging]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRSchemaStaging](
	[line] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRTable]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRTable](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[tab] [varchar](128) NULL,
	[istemp] [varchar](20) NULL,
	[addedon] [varchar](20) NULL,
	[db] [varchar](128) NULL,
	[hasschema] [bit] NULL,
	[hasrecords] [bit] NULL,
	[scansequence] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PRTablesStaging]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRTablesStaging](
	[tab] [varchar](128) NULL,
	[istemp] [varchar](128) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RStudioOneMeasure]    Script Date: 9/19/2017 2:19:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RStudioOneMeasure](
	[idd] [int] IDENTITY(1,1) NOT NULL,
	[measure] [float] NULL,
	[Grp] [varchar](32) NULL,
	[BIA] [varchar](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[idd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ABAggBIBODetailTracking] ADD  DEFAULT (getutcdate()) FOR [runat]
GO
ALTER TABLE [dbo].[ABAggBIBOSum] ADD  DEFAULT (getutcdate()) FOR [runat]
GO
ALTER TABLE [dbo].[ABAggLGCYDetailTracking] ADD  DEFAULT (getutcdate()) FOR [runat]
GO
ALTER TABLE [dbo].[ABAggLGCYSumTracking] ADD  DEFAULT (getutcdate()) FOR [runat]
GO
ALTER TABLE [dbo].[ABBiboModelDownload] ADD  DEFAULT (getutcdate()) FOR [lastupdated]
GO
ALTER TABLE [dbo].[ABBiboModelEnable] ADD  DEFAULT (getutcdate()) FOR [lastupdated]
GO
ALTER TABLE [dbo].[ABBiboModelValidation] ADD  DEFAULT (getutcdate()) FOR [lastupdated]
GO
ALTER TABLE [dbo].[ABConfig] ADD  DEFAULT (getutcdate()) FOR [addedon]
GO
ALTER TABLE [dbo].[ABDatalog] ADD  DEFAULT ((0)) FOR [isExists]
GO
ALTER TABLE [dbo].[ABDataTable] ADD  DEFAULT ((1)) FOR [isUsed]
GO
ALTER TABLE [dbo].[ABExpEnablementScanLog] ADD  DEFAULT ((0)) FOR [isenabled]
GO
ALTER TABLE [dbo].[ABExperiment] ADD  DEFAULT (getutcdate()) FOR [lastupdated]
GO
ALTER TABLE [dbo].[ABExperimentDate] ADD  DEFAULT ((1)) FOR [needReprocess]
GO
ALTER TABLE [dbo].[ABExperimentQuota] ADD  DEFAULT (getutcdate()) FOR [lastupdated]
GO
ALTER TABLE [dbo].[ABQueryLog] ADD  DEFAULT ((0)) FOR [hasFileError]
GO
ALTER TABLE [dbo].[ABQueryLog] ADD  DEFAULT ((0)) FOR [isChopped]
GO
ALTER TABLE [dbo].[ABQueryLog] ADD  DEFAULT ((0)) FOR [filtered]
GO
ALTER TABLE [dbo].[ABQueryLog] ADD  DEFAULT ((0)) FOR [examedbitwise]
GO
ALTER TABLE [dbo].[ABResult_t] ADD  DEFAULT (getutcdate()) FOR [testTime]
GO
ALTER TABLE [dbo].[ABResultPool] ADD  DEFAULT (getutcdate()) FOR [testTime]
GO
ALTER TABLE [dbo].[ABSampleLog] ADD  DEFAULT (getutcdate()) FOR [querygenerated]
GO
ALTER TABLE [dbo].[ABTableCandidate] ADD  DEFAULT ((0)) FOR [isWant]
GO
ALTER TABLE [dbo].[ABTableVolume] ADD  DEFAULT ((0)) FOR [Gathered]
GO
ALTER TABLE [dbo].[ABTableVolume] ADD  DEFAULT ((0)) FOR [BIAupdated]
GO
ALTER TABLE [dbo].[ABTest] ADD  DEFAULT (getutcdate()) FOR [generatedon]
GO
ALTER TABLE [dbo].[AlertFunctions] ADD  DEFAULT ((0)) FOR [subscribers]
GO
ALTER TABLE [dbo].[AlertFunctions] ADD  DEFAULT (getutcdate()) FOR [addedOn]
GO
ALTER TABLE [dbo].[PRDB] ADD  DEFAULT ((0)) FOR [isrun]
GO
ALTER TABLE [dbo].[PRSchemaException] ADD  DEFAULT (' value econding. ') FOR [reason]
GO
ALTER TABLE [dbo].[PRTable] ADD  DEFAULT ((0)) FOR [hasschema]
GO
ALTER TABLE [dbo].[PRTable] ADD  DEFAULT ((0)) FOR [hasrecords]
GO
