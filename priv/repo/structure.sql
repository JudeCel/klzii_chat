--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: enum_AccountUsers_emailNotification; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_AccountUsers_emailNotification" AS ENUM (
    'none',
    'privateMessages',
    'all'
);


ALTER TYPE "enum_AccountUsers_emailNotification" OWNER TO postgres;

--
-- Name: enum_AccountUsers_gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_AccountUsers_gender" AS ENUM (
    '',
    'male',
    'female',
    'neither'
);


ALTER TYPE "enum_AccountUsers_gender" OWNER TO postgres;

--
-- Name: enum_AccountUsers_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_AccountUsers_role" AS ENUM (
    'admin',
    'accountManager',
    'facilitator',
    'observer',
    'participant'
);


ALTER TYPE "enum_AccountUsers_role" OWNER TO postgres;

--
-- Name: enum_AccountUsers_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_AccountUsers_status" AS ENUM (
    'invited',
    'active',
    'inactive',
    'added'
);


ALTER TYPE "enum_AccountUsers_status" OWNER TO postgres;

--
-- Name: enum_Banners_page; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Banners_page" AS ENUM (
    'profile',
    'sessions',
    'resources'
);


ALTER TYPE "enum_Banners_page" OWNER TO postgres;

--
-- Name: enum_BrandProjectPreferences_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_BrandProjectPreferences_type" AS ENUM (
    'focus',
    'forum'
);


ALTER TYPE "enum_BrandProjectPreferences_type" OWNER TO postgres;

--
-- Name: enum_ContactLists_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_ContactLists_role" AS ENUM (
    'admin',
    'accountManager',
    'facilitator',
    'observer',
    'participant'
);


ALTER TYPE "enum_ContactLists_role" OWNER TO postgres;

--
-- Name: enum_Invites_emailStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Invites_emailStatus" AS ENUM (
    'waiting',
    'sent',
    'failed'
);


ALTER TYPE "enum_Invites_emailStatus" OWNER TO postgres;

--
-- Name: enum_Invites_mailProvider; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Invites_mailProvider" AS ENUM (
    'mailgun'
);


ALTER TYPE "enum_Invites_mailProvider" OWNER TO postgres;

--
-- Name: enum_Invites_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Invites_role" AS ENUM (
    'admin',
    'accountManager',
    'facilitator',
    'observer',
    'participant'
);


ALTER TYPE "enum_Invites_role" OWNER TO postgres;

--
-- Name: enum_Invites_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Invites_status" AS ENUM (
    'pending',
    'confirmed',
    'rejected',
    'notThisTime',
    'notAtAll',
    'expired',
    'inProgress',
    'sessionFull'
);


ALTER TYPE "enum_Invites_status" OWNER TO postgres;

--
-- Name: enum_MailTemplateBases_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_MailTemplateBases_category" AS ENUM (
    'firstInvitation',
    'closeSession',
    'confirmation',
    'generic',
    'notAtAll',
    'notThisTime',
    'accountManagerConfirmation',
    'reactivatedAccount',
    'deactivatedAccount',
    'facilitatorConfirmation',
    'observerInvitation',
    'facilitatorOverQuota',
    'invitationAcceptance',
    'sessionClosed',
    'sessionFull',
    'sessionNotYetOpen',
    'passwordResetSuccess',
    'passwordResetRequest',
    'passwordChangeSuccess',
    'registerConfirmationEmail',
    'registerConfirmationEmailSuccess',
    'emailNotification'
);


ALTER TYPE "enum_MailTemplateBases_category" OWNER TO postgres;

--
-- Name: enum_MiniSurveys_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_MiniSurveys_type" AS ENUM (
    'yesNoMaybe',
    '5starRating'
);


ALTER TYPE "enum_MiniSurveys_type" OWNER TO postgres;

--
-- Name: enum_Resources_scope; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Resources_scope" AS ENUM (
    'collage',
    'brandLogo',
    'zip',
    'pdf',
    'csv',
    'banner',
    'txt',
    'pinboard',
    'videoService'
);


ALTER TYPE "enum_Resources_scope" OWNER TO postgres;

--
-- Name: enum_Resources_source; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Resources_source" AS ENUM (
    'youtube',
    'vimeo'
);


ALTER TYPE "enum_Resources_source" OWNER TO postgres;

--
-- Name: enum_Resources_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Resources_status" AS ENUM (
    'completed',
    'progress',
    'failed'
);


ALTER TYPE "enum_Resources_status" OWNER TO postgres;

--
-- Name: enum_Resources_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Resources_type" AS ENUM (
    'video',
    'audio',
    'image',
    'file',
    'link'
);


ALTER TYPE "enum_Resources_type" OWNER TO postgres;

--
-- Name: enum_SessionMembers_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_SessionMembers_role" AS ENUM (
    'facilitator',
    'observer',
    'participant'
);


ALTER TYPE "enum_SessionMembers_role" OWNER TO postgres;

--
-- Name: enum_SessionMembers_typeOfCreation; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_SessionMembers_typeOfCreation" AS ENUM (
    'system',
    'invite'
);


ALTER TYPE "enum_SessionMembers_typeOfCreation" OWNER TO postgres;

--
-- Name: enum_SessionTopicsReports_format; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_SessionTopicsReports_format" AS ENUM (
    'txt',
    'csv',
    'pdf'
);


ALTER TYPE "enum_SessionTopicsReports_format" OWNER TO postgres;

--
-- Name: enum_SessionTopicsReports_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_SessionTopicsReports_status" AS ENUM (
    'completed',
    'progress',
    'failed'
);


ALTER TYPE "enum_SessionTopicsReports_status" OWNER TO postgres;

--
-- Name: enum_Sessions_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Sessions_status" AS ENUM (
    'open',
    'closed'
);


ALTER TYPE "enum_Sessions_status" OWNER TO postgres;

--
-- Name: enum_Sessions_step; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Sessions_step" AS ENUM (
    'setUp',
    'facilitatiorAndTopics',
    'manageSessionEmails',
    'manageSessionParticipants',
    'inviteSessionObservers'
);


ALTER TYPE "enum_Sessions_step" OWNER TO postgres;

--
-- Name: enum_SocialProfiles_provider; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_SocialProfiles_provider" AS ENUM (
    'facebook',
    'google'
);


ALTER TYPE "enum_SocialProfiles_provider" OWNER TO postgres;

--
-- Name: enum_SurveyQuestions_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_SurveyQuestions_type" AS ENUM (
    'radio',
    'textarea',
    'checkbox',
    'input'
);


ALTER TYPE "enum_SurveyQuestions_type" OWNER TO postgres;

--
-- Name: enum_Surveys_surveyType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_Surveys_surveyType" AS ENUM (
    'recruiter',
    'sessionContactList',
    'sessionPrizeDraw'
);


ALTER TYPE "enum_Surveys_surveyType" OWNER TO postgres;

--
-- Name: enum_UnreadMessages_scope; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE "enum_UnreadMessages_scope" AS ENUM (
    'reply',
    'normal'
);


ALTER TYPE "enum_UnreadMessages_scope" OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: AccountUsers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "AccountUsers" (
    id integer NOT NULL,
    "firstName" character varying(255) NOT NULL,
    "lastName" character varying(255) NOT NULL,
    gender "enum_AccountUsers_gender" NOT NULL,
    owner boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true NOT NULL,
    "reveiveNewsLetters" boolean DEFAULT false NOT NULL,
    role "enum_AccountUsers_role" NOT NULL,
    status "enum_AccountUsers_status" DEFAULT 'active'::"enum_AccountUsers_status" NOT NULL,
    state character varying(255),
    "postalAddress" character varying(255),
    city character varying(255),
    country character varying(255),
    "postCode" character varying(255),
    "companyName" character varying(255),
    "phoneCountryData" json DEFAULT '{"name":"Australia","iso2":"au","dialCode":"61"}'::json NOT NULL,
    "landlineNumberCountryData" json DEFAULT '{"name":"Australia","iso2":"au","dialCode":"61"}'::json NOT NULL,
    "landlineNumber" character varying(255),
    mobile character varying(255),
    comment text,
    email character varying(255) NOT NULL,
    "invitesInfo" json DEFAULT '{"NoInFuture":0,"NotAtAll":0,"Invites":0,"NoReply":0,"NotThisTime":0,"Future":"-","Accept":0,"LastSession":"-"}'::json NOT NULL,
    "emailNotification" "enum_AccountUsers_emailNotification" DEFAULT 'all'::"enum_AccountUsers_emailNotification" NOT NULL,
    "isRemoved" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "AccountId" integer,
    "UserId" integer
);


ALTER TABLE "AccountUsers" OWNER TO postgres;

--
-- Name: AccountUsers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "AccountUsers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "AccountUsers_id_seq" OWNER TO postgres;

--
-- Name: AccountUsers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "AccountUsers_id_seq" OWNED BY "AccountUsers".id;


--
-- Name: Accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Accounts" (
    id integer NOT NULL,
    "selectedPlanOnRegistration" character varying(255),
    admin boolean DEFAULT false NOT NULL,
    subdomain character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "Accounts" OWNER TO postgres;

--
-- Name: Accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Accounts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Accounts_id_seq" OWNER TO postgres;

--
-- Name: Accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Accounts_id_seq" OWNED BY "Accounts".id;


--
-- Name: Banners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Banners" (
    id integer NOT NULL,
    page "enum_Banners_page" NOT NULL,
    link character varying(255),
    "resourceId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "Banners" OWNER TO postgres;

--
-- Name: Banners_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Banners_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Banners_id_seq" OWNER TO postgres;

--
-- Name: Banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Banners_id_seq" OWNED BY "Banners".id;


--
-- Name: BrandProjectPreferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "BrandProjectPreferences" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "accountId" integer NOT NULL,
    colours jsonb DEFAULT '{"font": "#58595B", "email": {"hyperlinks": "#2F9F69", "acceptButton": "#4CB649", "notAtAllButton": "#E51D39", "notThisTimeButton": "#4CBFE9"}, "mainBorder": "#C3BE2E", "headerButton": "#4CBFE9", "mainBackground": "#FFFFFF", "browserBackground": "#EFEFEF", "consoleButtonActive": "#4CB649"}'::jsonb NOT NULL,
    type "enum_BrandProjectPreferences_type" DEFAULT 'focus'::"enum_BrandProjectPreferences_type" NOT NULL,
    "default" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    brand_project_id integer
);


ALTER TABLE "BrandProjectPreferences" OWNER TO postgres;

--
-- Name: BrandProjectPreferences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "BrandProjectPreferences_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "BrandProjectPreferences_id_seq" OWNER TO postgres;

--
-- Name: BrandProjectPreferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "BrandProjectPreferences_id_seq" OWNED BY "BrandProjectPreferences".id;


--
-- Name: BrandProjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "BrandProjects" (
    id integer NOT NULL,
    name character varying(255) DEFAULT 'untitled'::character varying NOT NULL,
    client_company_logo_url text,
    client_company_logo_thumbnail_url text,
    enable_chatroom_logo integer DEFAULT 0 NOT NULL,
    session_replay_date timestamp with time zone NOT NULL,
    moderator_active integer DEFAULT 1 NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE "BrandProjects" OWNER TO postgres;

--
-- Name: BrandProjects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "BrandProjects_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "BrandProjects_id_seq" OWNER TO postgres;

--
-- Name: BrandProjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "BrandProjects_id_seq" OWNED BY "BrandProjects".id;


--
-- Name: ConnectionLogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "ConnectionLogs" (
    id integer NOT NULL,
    "userId" integer,
    "accountUserId" integer,
    "accountId" integer,
    "responseTime" integer NOT NULL,
    level character varying(255) NOT NULL,
    application character varying(255) NOT NULL,
    meta jsonb DEFAULT '{}'::jsonb,
    req jsonb DEFAULT '{}'::jsonb,
    res jsonb DEFAULT '{}'::jsonb,
    "createdAt" timestamp with time zone
);


ALTER TABLE "ConnectionLogs" OWNER TO postgres;

--
-- Name: ConnectionLogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "ConnectionLogs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "ConnectionLogs_id_seq" OWNER TO postgres;

--
-- Name: ConnectionLogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "ConnectionLogs_id_seq" OWNED BY "ConnectionLogs".id;


--
-- Name: Consoles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Consoles" (
    id integer NOT NULL,
    "sessionTopicId" integer NOT NULL,
    "audioId" integer,
    "videoId" integer,
    pinboard boolean DEFAULT false NOT NULL,
    "fileId" integer,
    "miniSurveyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "imageId" integer
);


ALTER TABLE "Consoles" OWNER TO postgres;

--
-- Name: Consoles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Consoles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Consoles_id_seq" OWNER TO postgres;

--
-- Name: Consoles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Consoles_id_seq" OWNED BY "Consoles".id;


--
-- Name: ContactListUsers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "ContactListUsers" (
    id integer NOT NULL,
    "accountUserId" integer NOT NULL,
    "accountId" integer NOT NULL,
    "userId" integer,
    "contactListId" integer NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    "customFields" jsonb DEFAULT '{}'::jsonb NOT NULL,
    "unsubscribeToken" uuid,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "ContactListUsers" OWNER TO postgres;

--
-- Name: ContactListUsers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "ContactListUsers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "ContactListUsers_id_seq" OWNER TO postgres;

--
-- Name: ContactListUsers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "ContactListUsers_id_seq" OWNED BY "ContactListUsers".id;


--
-- Name: ContactLists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "ContactLists" (
    id integer NOT NULL,
    "accountId" integer NOT NULL,
    name character varying(255) NOT NULL,
    editable boolean DEFAULT true NOT NULL,
    active boolean DEFAULT true NOT NULL,
    role "enum_ContactLists_role" DEFAULT 'participant'::"enum_ContactLists_role" NOT NULL,
    "defaultFields" text[] DEFAULT ARRAY['firstName'::text, 'lastName'::text, 'gender'::text, 'email'::text, 'postalAddress'::text, 'city'::text, 'state'::text, 'country'::text, 'postCode'::text, 'companyName'::text, 'landlineNumber'::text, 'mobile'::text] NOT NULL,
    "visibleFields" text[] DEFAULT ARRAY['firstName'::text, 'lastName'::text, 'gender'::text, 'email'::text, 'postalAddress'::text, 'city'::text, 'state'::text, 'country'::text, 'postCode'::text, 'companyName'::text, 'landlineNumber'::text, 'mobile'::text] NOT NULL,
    "participantsFields" text[] DEFAULT ARRAY['Invites'::text, 'Accept'::text, 'NotThisTime'::text, 'NotAtAll'::text, 'NoReply'::text, 'Future'::text, 'LastSession'::text, 'Comments'::text] NOT NULL,
    "customFields" text[] DEFAULT ARRAY[]::text[] NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "ContactLists" OWNER TO postgres;

--
-- Name: ContactLists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "ContactLists_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "ContactLists_id_seq" OWNER TO postgres;

--
-- Name: ContactLists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "ContactLists_id_seq" OWNED BY "ContactLists".id;


--
-- Name: DirectMessages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "DirectMessages" (
    id integer NOT NULL,
    "senderId" integer NOT NULL,
    "recieverId" integer NOT NULL,
    "sessionId" integer NOT NULL,
    "readAt" timestamp with time zone,
    text text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "DirectMessages" OWNER TO postgres;

--
-- Name: DirectMessages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "DirectMessages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DirectMessages_id_seq" OWNER TO postgres;

--
-- Name: DirectMessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "DirectMessages_id_seq" OWNED BY "DirectMessages".id;


--
-- Name: Invites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Invites" (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    "sentAt" timestamp with time zone NOT NULL,
    role "enum_Invites_role" NOT NULL,
    "accountUserId" integer NOT NULL,
    status "enum_Invites_status" DEFAULT 'pending'::"enum_Invites_status" NOT NULL,
    "emailStatus" "enum_Invites_emailStatus" DEFAULT 'waiting'::"enum_Invites_emailStatus" NOT NULL,
    "mailProvider" "enum_Invites_mailProvider" DEFAULT 'mailgun'::"enum_Invites_mailProvider",
    "mailMessageId" character varying(255),
    "webhookMessage" character varying(255),
    "webhookEvent" character varying(255),
    "webhookTime" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "accountId" integer,
    "userId" integer,
    "sessionId" integer
);


ALTER TABLE "Invites" OWNER TO postgres;

--
-- Name: Invites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Invites_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Invites_id_seq" OWNER TO postgres;

--
-- Name: Invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Invites_id_seq" OWNED BY "Invites".id;


--
-- Name: MailTemplateBases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "MailTemplateBases" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    content text NOT NULL,
    "systemMessage" boolean NOT NULL,
    category "enum_MailTemplateBases_category" NOT NULL,
    "mailTemplateActive" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "MailTemplateBases" OWNER TO postgres;

--
-- Name: MailTemplateBases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "MailTemplateBases_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "MailTemplateBases_id_seq" OWNER TO postgres;

--
-- Name: MailTemplateBases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "MailTemplateBases_id_seq" OWNED BY "MailTemplateBases".id;


--
-- Name: MailTemplateResources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "MailTemplateResources" (
    id integer NOT NULL,
    "mailTemplateId" integer NOT NULL,
    "resourceId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "MailTemplateResources" OWNER TO postgres;

--
-- Name: MailTemplateResources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "MailTemplateResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "MailTemplateResources_id_seq" OWNER TO postgres;

--
-- Name: MailTemplateResources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "MailTemplateResources_id_seq" OWNED BY "MailTemplateResources".id;


--
-- Name: MailTemplates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "MailTemplates" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    content text NOT NULL,
    "systemMessage" boolean NOT NULL,
    "sessionId" integer,
    required boolean DEFAULT true NOT NULL,
    "isCopy" boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "MailTemplateBaseId" integer,
    "AccountId" integer
);


ALTER TABLE "MailTemplates" OWNER TO postgres;

--
-- Name: MailTemplates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "MailTemplates_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "MailTemplates_id_seq" OWNER TO postgres;

--
-- Name: MailTemplates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "MailTemplates_id_seq" OWNED BY "MailTemplates".id;


--
-- Name: Messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Messages" (
    id integer NOT NULL,
    "sessionMemberId" integer NOT NULL,
    "sessionTopicId" integer NOT NULL,
    "replyId" integer,
    "replyLevel" integer DEFAULT 0 NOT NULL,
    emotion integer DEFAULT 1 NOT NULL,
    body text NOT NULL,
    star boolean DEFAULT false NOT NULL,
    "childrenStars" integer[] DEFAULT ARRAY[]::integer[] NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "Messages" OWNER TO postgres;

--
-- Name: Messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Messages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Messages_id_seq" OWNER TO postgres;

--
-- Name: Messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Messages_id_seq" OWNED BY "Messages".id;


--
-- Name: MiniSurveyAnswers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "MiniSurveyAnswers" (
    id integer NOT NULL,
    "miniSurveyId" integer NOT NULL,
    "sessionMemberId" integer NOT NULL,
    answer jsonb NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "MiniSurveyAnswers" OWNER TO postgres;

--
-- Name: MiniSurveyAnswers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "MiniSurveyAnswers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "MiniSurveyAnswers_id_seq" OWNER TO postgres;

--
-- Name: MiniSurveyAnswers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "MiniSurveyAnswers_id_seq" OWNED BY "MiniSurveyAnswers".id;


--
-- Name: MiniSurveys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "MiniSurveys" (
    id integer NOT NULL,
    "sessionId" integer NOT NULL,
    "sessionTopicId" integer NOT NULL,
    title character varying(255) NOT NULL,
    question character varying(255) NOT NULL,
    type "enum_MiniSurveys_type" NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "MiniSurveys" OWNER TO postgres;

--
-- Name: MiniSurveys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "MiniSurveys_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "MiniSurveys_id_seq" OWNER TO postgres;

--
-- Name: MiniSurveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "MiniSurveys_id_seq" OWNED BY "MiniSurveys".id;


--
-- Name: PinboardResources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "PinboardResources" (
    id integer NOT NULL,
    "sessionTopicId" integer NOT NULL,
    "sessionMemberId" integer NOT NULL,
    "resourceId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "PinboardResources" OWNER TO postgres;

--
-- Name: PinboardResources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "PinboardResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "PinboardResources_id_seq" OWNER TO postgres;

--
-- Name: PinboardResources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "PinboardResources_id_seq" OWNED BY "PinboardResources".id;


--
-- Name: Resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Resources" (
    id integer NOT NULL,
    stock boolean DEFAULT false,
    "accountId" integer NOT NULL,
    name character varying(255),
    "accountUserId" integer,
    "topicId" integer,
    image text,
    video text,
    file text,
    audio text,
    link text,
    "expiryDate" timestamp with time zone,
    properties jsonb DEFAULT '{}'::jsonb NOT NULL,
    status "enum_Resources_status" DEFAULT 'completed'::"enum_Resources_status" NOT NULL,
    type "enum_Resources_type" NOT NULL,
    scope "enum_Resources_scope" NOT NULL,
    source "enum_Resources_source",
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "Resources" OWNER TO postgres;

--
-- Name: Resources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Resources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Resources_id_seq" OWNER TO postgres;

--
-- Name: Resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Resources_id_seq" OWNED BY "Resources".id;


--
-- Name: SessionMembers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SessionMembers" (
    id integer NOT NULL,
    "sessionId" integer NOT NULL,
    "accountUserId" integer,
    token character varying(255),
    username character varying(255) NOT NULL,
    colour character varying(255) NOT NULL,
    "avatarData" jsonb DEFAULT '{"base": 0, "body": -1, "desk": -1, "face": 5, "hair": -1, "head": -1}'::jsonb NOT NULL,
    "sessionTopicContext" jsonb DEFAULT '{}'::jsonb NOT NULL,
    "currentTopic" jsonb DEFAULT '{}'::jsonb NOT NULL,
    role "enum_SessionMembers_role" NOT NULL,
    comment text,
    rating integer DEFAULT 0 NOT NULL,
    "closeEmailSent" boolean DEFAULT false NOT NULL,
    "typeOfCreation" "enum_SessionMembers_typeOfCreation" DEFAULT 'invite'::"enum_SessionMembers_typeOfCreation" NOT NULL,
    ghost boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SessionMembers" OWNER TO postgres;

--
-- Name: SessionMembers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SessionMembers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SessionMembers_id_seq" OWNER TO postgres;

--
-- Name: SessionMembers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SessionMembers_id_seq" OWNED BY "SessionMembers".id;


--
-- Name: SessionResources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SessionResources" (
    id integer NOT NULL,
    "sessionId" integer NOT NULL,
    "resourceId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SessionResources" OWNER TO postgres;

--
-- Name: SessionResources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SessionResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SessionResources_id_seq" OWNER TO postgres;

--
-- Name: SessionResources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SessionResources_id_seq" OWNED BY "SessionResources".id;


--
-- Name: SessionSurveys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SessionSurveys" (
    id integer NOT NULL,
    "sessionId" integer NOT NULL,
    "surveyId" integer NOT NULL,
    active boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SessionSurveys" OWNER TO postgres;

--
-- Name: SessionSurveys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SessionSurveys_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SessionSurveys_id_seq" OWNER TO postgres;

--
-- Name: SessionSurveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SessionSurveys_id_seq" OWNED BY "SessionSurveys".id;


--
-- Name: SessionTopics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SessionTopics" (
    id integer NOT NULL,
    "topicId" integer NOT NULL,
    "sessionId" integer NOT NULL,
    "order" integer DEFAULT 0,
    active boolean DEFAULT true,
    landing boolean DEFAULT false,
    "boardMessage" text,
    name character varying(255),
    sign character varying(255),
    "lastSign" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SessionTopics" OWNER TO postgres;

--
-- Name: SessionTopicsReports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SessionTopicsReports" (
    id integer NOT NULL,
    "sessionId" integer NOT NULL,
    "sessionTopicId" integer,
    "resourceId" integer,
    type character varying(255) NOT NULL,
    scopes jsonb DEFAULT '{}'::jsonb NOT NULL,
    "includeFields" text[] DEFAULT ARRAY[]::text[] NOT NULL,
    includes jsonb DEFAULT '{}'::jsonb NOT NULL,
    format "enum_SessionTopicsReports_format" NOT NULL,
    status "enum_SessionTopicsReports_status" DEFAULT 'progress'::"enum_SessionTopicsReports_status" NOT NULL,
    message text,
    name character varying(255),
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SessionTopicsReports" OWNER TO postgres;

--
-- Name: SessionTopicsReports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SessionTopicsReports_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SessionTopicsReports_id_seq" OWNER TO postgres;

--
-- Name: SessionTopicsReports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SessionTopicsReports_id_seq" OWNED BY "SessionTopicsReports".id;


--
-- Name: SessionTopics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SessionTopics_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SessionTopics_id_seq" OWNER TO postgres;

--
-- Name: SessionTopics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SessionTopics_id_seq" OWNED BY "SessionTopics".id;


--
-- Name: SessionTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SessionTypes" (
    name character varying(255) NOT NULL,
    properties jsonb NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SessionTypes" OWNER TO postgres;

--
-- Name: Sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Sessions" (
    id integer NOT NULL,
    brand_project_id integer,
    "accountId" integer NOT NULL,
    "participantListId" integer,
    "brandProjectPreferenceId" integer,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    "startTime" timestamp with time zone,
    "endTime" timestamp with time zone,
    "timeZone" character varying(255) NOT NULL,
    incentive_details character varying(255),
    colours_used text,
    step "enum_Sessions_step" DEFAULT 'setUp'::"enum_Sessions_step" NOT NULL,
    status "enum_Sessions_status" DEFAULT 'open'::"enum_Sessions_status" NOT NULL,
    type character varying(255),
    anonymous boolean DEFAULT false NOT NULL,
    "isInactive" boolean DEFAULT false NOT NULL,
    "isVisited" json DEFAULT '{"setUp":false,"facilitatiorAndTopics":false,"manageSessionEmails":false,"manageSessionParticipants":false,"inviteSessionObservers":false}'::json NOT NULL,
    "publicUid" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "sessionId" integer,
    "resourceId" integer
);


ALTER TABLE "Sessions" OWNER TO postgres;

--
-- Name: Sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Sessions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Sessions_id_seq" OWNER TO postgres;

--
-- Name: Sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Sessions_id_seq" OWNED BY "Sessions".id;


--
-- Name: Shapes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Shapes" (
    id integer NOT NULL,
    "sessionMemberId" integer NOT NULL,
    "sessionTopicId" integer NOT NULL,
    uid character varying(255),
    event jsonb DEFAULT '{}'::jsonb NOT NULL,
    "eventType" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "Shapes" OWNER TO postgres;

--
-- Name: Shapes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Shapes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Shapes_id_seq" OWNER TO postgres;

--
-- Name: Shapes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Shapes_id_seq" OWNED BY "Shapes".id;


--
-- Name: SocialProfiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SocialProfiles" (
    id integer NOT NULL,
    provider "enum_SocialProfiles_provider" NOT NULL,
    "providerUserId" character varying(255) NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SocialProfiles" OWNER TO postgres;

--
-- Name: SocialProfiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SocialProfiles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SocialProfiles_id_seq" OWNER TO postgres;

--
-- Name: SocialProfiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SocialProfiles_id_seq" OWNED BY "SocialProfiles".id;


--
-- Name: SubscriptionPlans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SubscriptionPlans" (
    id integer NOT NULL,
    "sessionCount" integer NOT NULL,
    "contactListCount" integer NOT NULL,
    "recruiterContactListCount" integer NOT NULL,
    "importDatabase" boolean DEFAULT false NOT NULL,
    "brandLogoAndCustomColors" integer DEFAULT 0 NOT NULL,
    "contactListMemberCount" integer NOT NULL,
    "accountUserCount" integer NOT NULL,
    "exportContactListAndParticipantHistory" boolean DEFAULT false NOT NULL,
    "exportRecruiterSurveyData" boolean DEFAULT false NOT NULL,
    "accessKlzziForum" boolean DEFAULT true NOT NULL,
    "accessKlzziFocus" boolean DEFAULT true NOT NULL,
    "canInviteObserversToSession" boolean DEFAULT false NOT NULL,
    "planSmsCount" integer DEFAULT 0 NOT NULL,
    "discussionGuideTips" boolean DEFAULT true NOT NULL,
    "whiteboardFunctionality" boolean DEFAULT true NOT NULL,
    "uploadToGallery" boolean DEFAULT true NOT NULL,
    "reportingFunctions" boolean DEFAULT true NOT NULL,
    "availableOnTabletAndMobilePlatforms" boolean DEFAULT true NOT NULL,
    "customEmailInvitationAndReminderMessages" boolean DEFAULT true NOT NULL,
    "topicCount" integer NOT NULL,
    priority integer NOT NULL,
    "surveyCount" integer NOT NULL,
    "canBuySms" boolean DEFAULT false NOT NULL,
    "chargebeePlanId" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE "SubscriptionPlans" OWNER TO postgres;

--
-- Name: SubscriptionPlans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SubscriptionPlans_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SubscriptionPlans_id_seq" OWNER TO postgres;

--
-- Name: SubscriptionPlans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SubscriptionPlans_id_seq" OWNED BY "SubscriptionPlans".id;


--
-- Name: SubscriptionPreferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SubscriptionPreferences" (
    id integer NOT NULL,
    "subscriptionId" integer NOT NULL,
    data jsonb NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SubscriptionPreferences" OWNER TO postgres;

--
-- Name: SubscriptionPreferences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SubscriptionPreferences_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SubscriptionPreferences_id_seq" OWNER TO postgres;

--
-- Name: SubscriptionPreferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SubscriptionPreferences_id_seq" OWNED BY "SubscriptionPreferences".id;


--
-- Name: Subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Subscriptions" (
    id integer NOT NULL,
    "accountId" integer NOT NULL,
    "subscriptionPlanId" integer NOT NULL,
    "planId" character varying(255) NOT NULL,
    "customerId" character varying(255) NOT NULL,
    "lastWebhookId" character varying(255),
    "subscriptionId" character varying(255) NOT NULL,
    active boolean DEFAULT true,
    "endDate" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE "Subscriptions" OWNER TO postgres;

--
-- Name: Subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Subscriptions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Subscriptions_id_seq" OWNER TO postgres;

--
-- Name: Subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Subscriptions_id_seq" OWNED BY "Subscriptions".id;


--
-- Name: SurveyAnswers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SurveyAnswers" (
    id integer NOT NULL,
    "surveyId" integer NOT NULL,
    answers jsonb NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SurveyAnswers" OWNER TO postgres;

--
-- Name: SurveyAnswers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SurveyAnswers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SurveyAnswers_id_seq" OWNER TO postgres;

--
-- Name: SurveyAnswers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SurveyAnswers_id_seq" OWNED BY "SurveyAnswers".id;


--
-- Name: SurveyQuestions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SurveyQuestions" (
    id integer NOT NULL,
    "surveyId" integer NOT NULL,
    "resourceId" integer,
    required boolean DEFAULT false NOT NULL,
    name character varying(255) NOT NULL,
    question text NOT NULL,
    "order" integer NOT NULL,
    type "enum_SurveyQuestions_type" NOT NULL,
    answers jsonb NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "SurveyQuestions" OWNER TO postgres;

--
-- Name: SurveyQuestions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "SurveyQuestions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "SurveyQuestions_id_seq" OWNER TO postgres;

--
-- Name: SurveyQuestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "SurveyQuestions_id_seq" OWNED BY "SurveyQuestions".id;


--
-- Name: Surveys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Surveys" (
    id integer NOT NULL,
    "accountId" integer NOT NULL,
    "resourceId" integer,
    "contactListId" integer,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    thanks character varying(255) NOT NULL,
    closed boolean DEFAULT false,
    "confirmedAt" timestamp with time zone,
    "closedAt" timestamp with time zone,
    url character varying(255),
    "surveyType" "enum_Surveys_surveyType" DEFAULT 'recruiter'::"enum_Surveys_surveyType" NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "Surveys" OWNER TO postgres;

--
-- Name: Surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Surveys_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Surveys_id_seq" OWNER TO postgres;

--
-- Name: Surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Surveys_id_seq" OWNED BY "Surveys".id;


--
-- Name: Topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Topics" (
    id integer NOT NULL,
    "accountId" integer NOT NULL,
    "parentTopicId" integer,
    "boardMessage" character varying(255),
    name character varying(255) NOT NULL,
    sign character varying(255),
    "default" boolean DEFAULT false NOT NULL,
    stock boolean DEFAULT false NOT NULL,
    "inviteAgain" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "Topics" OWNER TO postgres;

--
-- Name: Topics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Topics_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Topics_id_seq" OWNER TO postgres;

--
-- Name: Topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Topics_id_seq" OWNED BY "Topics".id;


--
-- Name: UnreadMessages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "UnreadMessages" (
    id integer NOT NULL,
    "sessionMemberId" integer NOT NULL,
    "messageId" integer,
    "sessionTopicId" integer NOT NULL,
    scope "enum_UnreadMessages_scope" DEFAULT 'normal'::"enum_UnreadMessages_scope" NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "UnreadMessages" OWNER TO postgres;

--
-- Name: UnreadMessages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "UnreadMessages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "UnreadMessages_id_seq" OWNER TO postgres;

--
-- Name: UnreadMessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "UnreadMessages_id_seq" OWNED BY "UnreadMessages".id;


--
-- Name: Users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Users" (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    "encryptedPassword" character varying(255) NOT NULL,
    "resetPasswordToken" character varying(255),
    "resetPasswordSentAt" timestamp with time zone,
    "confirmationToken" character varying(255),
    "confirmationSentAt" timestamp with time zone,
    "confirmedAt" timestamp with time zone,
    "currentSignInIp" character varying(255),
    "signInCount" integer DEFAULT 0 NOT NULL,
    "tipsAndUpdate" boolean DEFAULT true NOT NULL,
    "selectedPlanOnRegistration" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE "Users" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Users_id_seq" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Users_id_seq" OWNED BY "Users".id;


--
-- Name: Votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Votes" (
    id integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "messageId" integer,
    "sessionMemberId" integer
);


ALTER TABLE "Votes" OWNER TO postgres;

--
-- Name: Votes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Votes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Votes_id_seq" OWNER TO postgres;

--
-- Name: Votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Votes_id_seq" OWNED BY "Votes".id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


ALTER TABLE schema_migrations OWNER TO postgres;

--
-- Name: session_staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE session_staff (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "topicId" integer NOT NULL,
    "sessionId" integer NOT NULL,
    comments text,
    type character varying(255),
    active boolean NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE session_staff OWNER TO postgres;

--
-- Name: session_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE session_staff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE session_staff_id_seq OWNER TO postgres;

--
-- Name: session_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE session_staff_id_seq OWNED BY session_staff.id;


--
-- Name: AccountUsers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AccountUsers" ALTER COLUMN id SET DEFAULT nextval('"AccountUsers_id_seq"'::regclass);


--
-- Name: Accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Accounts" ALTER COLUMN id SET DEFAULT nextval('"Accounts_id_seq"'::regclass);


--
-- Name: Banners id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Banners" ALTER COLUMN id SET DEFAULT nextval('"Banners_id_seq"'::regclass);


--
-- Name: BrandProjectPreferences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "BrandProjectPreferences" ALTER COLUMN id SET DEFAULT nextval('"BrandProjectPreferences_id_seq"'::regclass);


--
-- Name: BrandProjects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "BrandProjects" ALTER COLUMN id SET DEFAULT nextval('"BrandProjects_id_seq"'::regclass);


--
-- Name: ConnectionLogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ConnectionLogs" ALTER COLUMN id SET DEFAULT nextval('"ConnectionLogs_id_seq"'::regclass);


--
-- Name: Consoles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Consoles" ALTER COLUMN id SET DEFAULT nextval('"Consoles_id_seq"'::regclass);


--
-- Name: ContactListUsers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactListUsers" ALTER COLUMN id SET DEFAULT nextval('"ContactListUsers_id_seq"'::regclass);


--
-- Name: ContactLists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactLists" ALTER COLUMN id SET DEFAULT nextval('"ContactLists_id_seq"'::regclass);


--
-- Name: DirectMessages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "DirectMessages" ALTER COLUMN id SET DEFAULT nextval('"DirectMessages_id_seq"'::regclass);


--
-- Name: Invites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Invites" ALTER COLUMN id SET DEFAULT nextval('"Invites_id_seq"'::regclass);


--
-- Name: MailTemplateBases id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplateBases" ALTER COLUMN id SET DEFAULT nextval('"MailTemplateBases_id_seq"'::regclass);


--
-- Name: MailTemplateResources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplateResources" ALTER COLUMN id SET DEFAULT nextval('"MailTemplateResources_id_seq"'::regclass);


--
-- Name: MailTemplates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplates" ALTER COLUMN id SET DEFAULT nextval('"MailTemplates_id_seq"'::regclass);


--
-- Name: Messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Messages" ALTER COLUMN id SET DEFAULT nextval('"Messages_id_seq"'::regclass);


--
-- Name: MiniSurveyAnswers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MiniSurveyAnswers" ALTER COLUMN id SET DEFAULT nextval('"MiniSurveyAnswers_id_seq"'::regclass);


--
-- Name: MiniSurveys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MiniSurveys" ALTER COLUMN id SET DEFAULT nextval('"MiniSurveys_id_seq"'::regclass);


--
-- Name: PinboardResources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PinboardResources" ALTER COLUMN id SET DEFAULT nextval('"PinboardResources_id_seq"'::regclass);


--
-- Name: Resources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Resources" ALTER COLUMN id SET DEFAULT nextval('"Resources_id_seq"'::regclass);


--
-- Name: SessionMembers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionMembers" ALTER COLUMN id SET DEFAULT nextval('"SessionMembers_id_seq"'::regclass);


--
-- Name: SessionResources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionResources" ALTER COLUMN id SET DEFAULT nextval('"SessionResources_id_seq"'::regclass);


--
-- Name: SessionSurveys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionSurveys" ALTER COLUMN id SET DEFAULT nextval('"SessionSurveys_id_seq"'::regclass);


--
-- Name: SessionTopics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopics" ALTER COLUMN id SET DEFAULT nextval('"SessionTopics_id_seq"'::regclass);


--
-- Name: SessionTopicsReports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopicsReports" ALTER COLUMN id SET DEFAULT nextval('"SessionTopicsReports_id_seq"'::regclass);


--
-- Name: Sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions" ALTER COLUMN id SET DEFAULT nextval('"Sessions_id_seq"'::regclass);


--
-- Name: Shapes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Shapes" ALTER COLUMN id SET DEFAULT nextval('"Shapes_id_seq"'::regclass);


--
-- Name: SocialProfiles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SocialProfiles" ALTER COLUMN id SET DEFAULT nextval('"SocialProfiles_id_seq"'::regclass);


--
-- Name: SubscriptionPlans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SubscriptionPlans" ALTER COLUMN id SET DEFAULT nextval('"SubscriptionPlans_id_seq"'::regclass);


--
-- Name: SubscriptionPreferences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SubscriptionPreferences" ALTER COLUMN id SET DEFAULT nextval('"SubscriptionPreferences_id_seq"'::regclass);


--
-- Name: Subscriptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Subscriptions" ALTER COLUMN id SET DEFAULT nextval('"Subscriptions_id_seq"'::regclass);


--
-- Name: SurveyAnswers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SurveyAnswers" ALTER COLUMN id SET DEFAULT nextval('"SurveyAnswers_id_seq"'::regclass);


--
-- Name: SurveyQuestions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SurveyQuestions" ALTER COLUMN id SET DEFAULT nextval('"SurveyQuestions_id_seq"'::regclass);


--
-- Name: Surveys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Surveys" ALTER COLUMN id SET DEFAULT nextval('"Surveys_id_seq"'::regclass);


--
-- Name: Topics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Topics" ALTER COLUMN id SET DEFAULT nextval('"Topics_id_seq"'::regclass);


--
-- Name: UnreadMessages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "UnreadMessages" ALTER COLUMN id SET DEFAULT nextval('"UnreadMessages_id_seq"'::regclass);


--
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Users" ALTER COLUMN id SET DEFAULT nextval('"Users_id_seq"'::regclass);


--
-- Name: Votes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Votes" ALTER COLUMN id SET DEFAULT nextval('"Votes_id_seq"'::regclass);


--
-- Name: session_staff id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY session_staff ALTER COLUMN id SET DEFAULT nextval('session_staff_id_seq'::regclass);


--
-- Data for Name: AccountUsers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "AccountUsers" (id, "firstName", "lastName", gender, owner, active, "reveiveNewsLetters", role, status, state, "postalAddress", city, country, "postCode", "companyName", "phoneCountryData", "landlineNumberCountryData", "landlineNumber", mobile, comment, email, "invitesInfo", "emailNotification", "isRemoved", "createdAt", "updatedAt", "AccountId", "UserId") FROM stdin;
\.


--
-- Name: AccountUsers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"AccountUsers_id_seq"', 1241, true);


--
-- Data for Name: Accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Accounts" (id, "selectedPlanOnRegistration", admin, subdomain, name, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Accounts_id_seq"', 554, true);


--
-- Data for Name: Banners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Banners" (id, page, link, "resourceId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Banners_id_seq"', 1, false);


--
-- Data for Name: BrandProjectPreferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "BrandProjectPreferences" (id, name, "accountId", colours, type, "default", "createdAt", "updatedAt", brand_project_id) FROM stdin;
\.


--
-- Name: BrandProjectPreferences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"BrandProjectPreferences_id_seq"', 1, false);


--
-- Data for Name: BrandProjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "BrandProjects" (id, name, client_company_logo_url, client_company_logo_thumbnail_url, enable_chatroom_logo, session_replay_date, moderator_active, "createdAt", "updatedAt", "deletedAt") FROM stdin;
\.


--
-- Name: BrandProjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"BrandProjects_id_seq"', 1, false);


--
-- Data for Name: ConnectionLogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "ConnectionLogs" (id, "userId", "accountUserId", "accountId", "responseTime", level, application, meta, req, res, "createdAt") FROM stdin;
\.


--
-- Name: ConnectionLogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"ConnectionLogs_id_seq"', 2, true);


--
-- Data for Name: Consoles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Consoles" (id, "sessionTopicId", "audioId", "videoId", pinboard, "fileId", "miniSurveyId", "createdAt", "updatedAt", "imageId") FROM stdin;
\.


--
-- Name: Consoles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Consoles_id_seq"', 42, true);


--
-- Data for Name: ContactListUsers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "ContactListUsers" (id, "accountUserId", "accountId", "userId", "contactListId", "position", "customFields", "unsubscribeToken", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: ContactListUsers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"ContactListUsers_id_seq"', 687, true);


--
-- Data for Name: ContactLists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "ContactLists" (id, "accountId", name, editable, active, role, "defaultFields", "visibleFields", "participantsFields", "customFields", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: ContactLists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"ContactLists_id_seq"', 229, true);


--
-- Data for Name: DirectMessages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "DirectMessages" (id, "senderId", "recieverId", "sessionId", "readAt", text, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: DirectMessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"DirectMessages_id_seq"', 15, true);


--
-- Data for Name: Invites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Invites" (id, token, "sentAt", role, "accountUserId", status, "emailStatus", "mailProvider", "mailMessageId", "webhookMessage", "webhookEvent", "webhookTime", "createdAt", "updatedAt", "accountId", "userId", "sessionId") FROM stdin;
\.


--
-- Name: Invites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Invites_id_seq"', 6, true);


--
-- Data for Name: MailTemplateBases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "MailTemplateBases" (id, name, subject, content, "systemMessage", category, "mailTemplateActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: MailTemplateBases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"MailTemplateBases_id_seq"', 1, false);


--
-- Data for Name: MailTemplateResources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "MailTemplateResources" (id, "mailTemplateId", "resourceId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: MailTemplateResources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"MailTemplateResources_id_seq"', 1, false);


--
-- Data for Name: MailTemplates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "MailTemplates" (id, name, subject, content, "systemMessage", "sessionId", required, "isCopy", "createdAt", "updatedAt", "MailTemplateBaseId", "AccountId") FROM stdin;
\.


--
-- Name: MailTemplates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"MailTemplates_id_seq"', 1, false);


--
-- Data for Name: Messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Messages" (id, "sessionMemberId", "sessionTopicId", "replyId", "replyLevel", emotion, body, star, "childrenStars", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Messages_id_seq"', 147, true);


--
-- Data for Name: MiniSurveyAnswers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "MiniSurveyAnswers" (id, "miniSurveyId", "sessionMemberId", answer, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: MiniSurveyAnswers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"MiniSurveyAnswers_id_seq"', 19, true);


--
-- Data for Name: MiniSurveys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "MiniSurveys" (id, "sessionId", "sessionTopicId", title, question, type, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: MiniSurveys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"MiniSurveys_id_seq"', 42, true);


--
-- Data for Name: PinboardResources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "PinboardResources" (id, "sessionTopicId", "sessionMemberId", "resourceId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: PinboardResources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"PinboardResources_id_seq"', 5, true);


--
-- Data for Name: Resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Resources" (id, stock, "accountId", name, "accountUserId", "topicId", image, video, file, audio, link, "expiryDate", properties, status, type, scope, source, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Resources_id_seq"', 122, true);


--
-- Data for Name: SessionMembers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SessionMembers" (id, "sessionId", "accountUserId", token, username, colour, "avatarData", "sessionTopicContext", "currentTopic", role, comment, rating, "closeEmailSent", "typeOfCreation", ghost, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: SessionMembers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SessionMembers_id_seq"', 1374, true);


--
-- Data for Name: SessionResources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SessionResources" (id, "sessionId", "resourceId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: SessionResources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SessionResources_id_seq"', 17, true);


--
-- Data for Name: SessionSurveys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SessionSurveys" (id, "sessionId", "surveyId", active, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: SessionSurveys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SessionSurveys_id_seq"', 7, true);


--
-- Data for Name: SessionTopics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SessionTopics" (id, "topicId", "sessionId", "order", active, landing, "boardMessage", name, sign, "lastSign", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: SessionTopicsReports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SessionTopicsReports" (id, "sessionId", "sessionTopicId", "resourceId", type, scopes, "includeFields", includes, format, status, message, name, "deletedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: SessionTopicsReports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SessionTopicsReports_id_seq"', 121, true);


--
-- Name: SessionTopics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SessionTopics_id_seq"', 687, true);


--
-- Data for Name: SessionTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SessionTypes" (name, properties, "createdAt", "updatedAt") FROM stdin;
focus	{"steps": {"setUp": {"enabled": true}, "manageSessionEmails": {"enabled": true}, "facilitatiorAndTopics": {"enabled": true}, "inviteSessionObservers": {"enabled": true, "sendGroupSms": false}, "manageSessionParticipants": {"enabled": true, "sendGroupSms": true}}, "features": {"survay": {"enabled": false}, "publish": {"enabled": false}, "sendSms": {"enabled": true}, "pinboard": {"enabled": true}, "anonymous": {"enabled": true}, "whiteboard": {"enabled": true, "canWrite": ["facilitator", "participant"]}, "colorScheme": {"type": "focus"}, "dateAndTime": {"enabled": true}, "inviteAgainTopic": {"enabled": false}, "ghostParticipants": {"enabled": false}, "closeSessionButton": {"enabled": true}, "closeSessionToggle": {"enabled": false}, "socialMediaGraphics": {"enabled": false}}, "validations": {"observer": {"max": -1}, "participant": {"max": 8}}}	2017-03-20 11:38:08.63+02	2017-03-20 11:38:08.63+02
forum	{"steps": {"setUp": {"enabled": true}, "manageSessionEmails": {"enabled": true}, "facilitatiorAndTopics": {"enabled": true}, "inviteSessionObservers": {"enabled": true, "sendGroupSms": false}, "manageSessionParticipants": {"enabled": true, "sendGroupSms": false}}, "features": {"survay": {"enabled": false}, "publish": {"enabled": false}, "sendSms": {"enabled": false}, "pinboard": {"enabled": false}, "anonymous": {"enabled": true}, "whiteboard": {"enabled": true, "canWrite": ["facilitator"]}, "colorScheme": {"type": "forum"}, "dateAndTime": {"enabled": true}, "inviteAgainTopic": {"enabled": false}, "ghostParticipants": {"enabled": false}, "closeSessionButton": {"enabled": true}, "closeSessionToggle": {"enabled": false}, "socialMediaGraphics": {"enabled": false}}, "validations": {"observer": {"max": -1}, "participant": {"max": -1}}}	2017-03-20 11:38:08.641+02	2017-03-20 11:38:08.641+02
socialForum	{"steps": {"setUp": {"enabled": true}, "message": "It's even easier to build Social Forum, so you don't need steps 3 to 5.", "manageSessionEmails": {"enabled": false}, "facilitatiorAndTopics": {"enabled": true, "hideNext": true}, "inviteSessionObservers": {"enabled": false}, "manageSessionParticipants": {"enabled": false}}, "features": {"survay": {"enabled": true}, "publish": {"enabled": true}, "sendSms": {"enabled": false}, "pinboard": {"enabled": false}, "anonymous": {"enabled": false}, "whiteboard": {"enabled": true, "canWrite": ["facilitator"]}, "colorScheme": {"type": "forum"}, "dateAndTime": {"enabled": false, "message": "Yay! One less thing you have to do.<br/>Start & End Date isn't required<br/>with Social Forum"}, "inviteAgainTopic": {"enabled": true}, "ghostParticipants": {"enabled": true}, "closeSessionButton": {"enabled": false}, "closeSessionToggle": {"enabled": true}, "socialMediaGraphics": {"enabled": true, "message": "We're currently building an exciting tool for you to customize your social media posts and help your Chat Session stand out. We'll keep you updated on progress ☺"}}, "validations": {"observer": {"max": 0}, "participant": {"max": 0}}}	2017-03-20 11:38:08.645+02	2017-03-20 11:38:08.645+02
\.


--
-- Data for Name: Sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Sessions" (id, brand_project_id, "accountId", "participantListId", "brandProjectPreferenceId", name, "startTime", "endTime", "timeZone", incentive_details, colours_used, step, status, type, anonymous, "isInactive", "isVisited", "publicUid", "createdAt", "updatedAt", "sessionId", "resourceId") FROM stdin;
\.


--
-- Name: Sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Sessions_id_seq"', 458, true);


--
-- Data for Name: Shapes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Shapes" (id, "sessionMemberId", "sessionTopicId", uid, event, "eventType", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Shapes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Shapes_id_seq"', 12, true);


--
-- Data for Name: SocialProfiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SocialProfiles" (id, provider, "providerUserId", "userId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: SocialProfiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SocialProfiles_id_seq"', 1, false);


--
-- Data for Name: SubscriptionPlans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SubscriptionPlans" (id, "sessionCount", "contactListCount", "recruiterContactListCount", "importDatabase", "brandLogoAndCustomColors", "contactListMemberCount", "accountUserCount", "exportContactListAndParticipantHistory", "exportRecruiterSurveyData", "accessKlzziForum", "accessKlzziFocus", "canInviteObserversToSession", "planSmsCount", "discussionGuideTips", "whiteboardFunctionality", "uploadToGallery", "reportingFunctions", "availableOnTabletAndMobilePlatforms", "customEmailInvitationAndReminderMessages", "topicCount", priority, "surveyCount", "canBuySms", "chargebeePlanId", "createdAt", "updatedAt", "deletedAt") FROM stdin;
\.


--
-- Name: SubscriptionPlans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SubscriptionPlans_id_seq"', 301, true);


--
-- Data for Name: SubscriptionPreferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SubscriptionPreferences" (id, "subscriptionId", data, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: SubscriptionPreferences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SubscriptionPreferences_id_seq"', 301, true);


--
-- Data for Name: Subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Subscriptions" (id, "accountId", "subscriptionPlanId", "planId", "customerId", "lastWebhookId", "subscriptionId", active, "endDate", "createdAt", "updatedAt", "deletedAt") FROM stdin;
\.


--
-- Name: Subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Subscriptions_id_seq"', 301, true);


--
-- Data for Name: SurveyAnswers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SurveyAnswers" (id, "surveyId", answers, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: SurveyAnswers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SurveyAnswers_id_seq"', 9, true);


--
-- Data for Name: SurveyQuestions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SurveyQuestions" (id, "surveyId", "resourceId", required, name, question, "order", type, answers, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: SurveyQuestions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"SurveyQuestions_id_seq"', 4, true);


--
-- Data for Name: Surveys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Surveys" (id, "accountId", "resourceId", "contactListId", name, description, thanks, closed, "confirmedAt", "closedAt", url, "surveyType", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Surveys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Surveys_id_seq"', 14, true);


--
-- Data for Name: Topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Topics" (id, "accountId", "parentTopicId", "boardMessage", name, sign, "default", stock, "inviteAgain", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Topics_id_seq"', 458, true);


--
-- Data for Name: UnreadMessages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "UnreadMessages" (id, "sessionMemberId", "messageId", "sessionTopicId", scope, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: UnreadMessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"UnreadMessages_id_seq"', 53, true);


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Users" (id, email, "encryptedPassword", "resetPasswordToken", "resetPasswordSentAt", "confirmationToken", "confirmationSentAt", "confirmedAt", "currentSignInIp", "signInCount", "tipsAndUpdate", "selectedPlanOnRegistration", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Users_id_seq"', 1241, true);


--
-- Data for Name: Votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Votes" (id, "createdAt", "updatedAt", "messageId", "sessionMemberId") FROM stdin;
\.


--
-- Name: Votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Votes_id_seq"', 1, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_migrations (version, inserted_at) FROM stdin;
\.


--
-- Data for Name: session_staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY session_staff (id, "userId", "topicId", "sessionId", comments, type, active, "createdAt", "updatedAt", "deletedAt") FROM stdin;
\.


--
-- Name: session_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('session_staff_id_seq', 1, false);


--
-- Name: AccountUsers AccountUsers_AccountId_UserId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AccountUsers"
    ADD CONSTRAINT "AccountUsers_AccountId_UserId_key" UNIQUE ("AccountId", "UserId");


--
-- Name: AccountUsers AccountUsers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AccountUsers"
    ADD CONSTRAINT "AccountUsers_pkey" PRIMARY KEY (id);


--
-- Name: Accounts Accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Accounts"
    ADD CONSTRAINT "Accounts_pkey" PRIMARY KEY (id);


--
-- Name: Banners Banners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Banners"
    ADD CONSTRAINT "Banners_pkey" PRIMARY KEY (id);


--
-- Name: BrandProjectPreferences BrandProjectPreferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "BrandProjectPreferences"
    ADD CONSTRAINT "BrandProjectPreferences_pkey" PRIMARY KEY (id);


--
-- Name: BrandProjects BrandProjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "BrandProjects"
    ADD CONSTRAINT "BrandProjects_pkey" PRIMARY KEY (id);


--
-- Name: ConnectionLogs ConnectionLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ConnectionLogs"
    ADD CONSTRAINT "ConnectionLogs_pkey" PRIMARY KEY (id);


--
-- Name: Consoles Consoles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Consoles"
    ADD CONSTRAINT "Consoles_pkey" PRIMARY KEY (id);


--
-- Name: ContactListUsers ContactListUsers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactListUsers"
    ADD CONSTRAINT "ContactListUsers_pkey" PRIMARY KEY (id);


--
-- Name: ContactLists ContactLists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactLists"
    ADD CONSTRAINT "ContactLists_pkey" PRIMARY KEY (id);


--
-- Name: DirectMessages DirectMessages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "DirectMessages"
    ADD CONSTRAINT "DirectMessages_pkey" PRIMARY KEY (id);


--
-- Name: Invites Invites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Invites"
    ADD CONSTRAINT "Invites_pkey" PRIMARY KEY (id);


--
-- Name: MailTemplateBases MailTemplateBases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplateBases"
    ADD CONSTRAINT "MailTemplateBases_pkey" PRIMARY KEY (id);


--
-- Name: MailTemplateResources MailTemplateResources_mailTemplateId_resourceId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplateResources"
    ADD CONSTRAINT "MailTemplateResources_mailTemplateId_resourceId_key" UNIQUE ("mailTemplateId", "resourceId");


--
-- Name: MailTemplateResources MailTemplateResources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplateResources"
    ADD CONSTRAINT "MailTemplateResources_pkey" PRIMARY KEY (id);


--
-- Name: MailTemplates MailTemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplates"
    ADD CONSTRAINT "MailTemplates_pkey" PRIMARY KEY (id);


--
-- Name: Messages Messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Messages"
    ADD CONSTRAINT "Messages_pkey" PRIMARY KEY (id);


--
-- Name: MiniSurveyAnswers MiniSurveyAnswers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MiniSurveyAnswers"
    ADD CONSTRAINT "MiniSurveyAnswers_pkey" PRIMARY KEY (id);


--
-- Name: MiniSurveys MiniSurveys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MiniSurveys"
    ADD CONSTRAINT "MiniSurveys_pkey" PRIMARY KEY (id);


--
-- Name: PinboardResources PinboardResources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PinboardResources"
    ADD CONSTRAINT "PinboardResources_pkey" PRIMARY KEY (id);


--
-- Name: Resources Resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Resources"
    ADD CONSTRAINT "Resources_pkey" PRIMARY KEY (id);


--
-- Name: SessionMembers SessionMembers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionMembers"
    ADD CONSTRAINT "SessionMembers_pkey" PRIMARY KEY (id);


--
-- Name: SessionResources SessionResources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionResources"
    ADD CONSTRAINT "SessionResources_pkey" PRIMARY KEY (id);


--
-- Name: SessionResources SessionResources_sessionId_resourceId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionResources"
    ADD CONSTRAINT "SessionResources_sessionId_resourceId_key" UNIQUE ("sessionId", "resourceId");


--
-- Name: SessionSurveys SessionSurveys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionSurveys"
    ADD CONSTRAINT "SessionSurveys_pkey" PRIMARY KEY (id);


--
-- Name: SessionSurveys SessionSurveys_sessionId_surveyId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionSurveys"
    ADD CONSTRAINT "SessionSurveys_sessionId_surveyId_key" UNIQUE ("sessionId", "surveyId");


--
-- Name: SessionTopicsReports SessionTopicsReports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopicsReports"
    ADD CONSTRAINT "SessionTopicsReports_pkey" PRIMARY KEY (id);


--
-- Name: SessionTopics SessionTopics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopics"
    ADD CONSTRAINT "SessionTopics_pkey" PRIMARY KEY (id);


--
-- Name: SessionTopics SessionTopics_topicId_sessionId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopics"
    ADD CONSTRAINT "SessionTopics_topicId_sessionId_key" UNIQUE ("topicId", "sessionId");


--
-- Name: SessionTypes SessionTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTypes"
    ADD CONSTRAINT "SessionTypes_pkey" PRIMARY KEY (name);


--
-- Name: Sessions Sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions"
    ADD CONSTRAINT "Sessions_pkey" PRIMARY KEY (id);


--
-- Name: Shapes Shapes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Shapes"
    ADD CONSTRAINT "Shapes_pkey" PRIMARY KEY (id);


--
-- Name: SocialProfiles SocialProfiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SocialProfiles"
    ADD CONSTRAINT "SocialProfiles_pkey" PRIMARY KEY (id);


--
-- Name: SubscriptionPlans SubscriptionPlans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SubscriptionPlans"
    ADD CONSTRAINT "SubscriptionPlans_pkey" PRIMARY KEY (id);


--
-- Name: SubscriptionPreferences SubscriptionPreferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SubscriptionPreferences"
    ADD CONSTRAINT "SubscriptionPreferences_pkey" PRIMARY KEY (id);


--
-- Name: Subscriptions Subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Subscriptions"
    ADD CONSTRAINT "Subscriptions_pkey" PRIMARY KEY (id);


--
-- Name: SurveyAnswers SurveyAnswers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SurveyAnswers"
    ADD CONSTRAINT "SurveyAnswers_pkey" PRIMARY KEY (id);


--
-- Name: SurveyQuestions SurveyQuestions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SurveyQuestions"
    ADD CONSTRAINT "SurveyQuestions_pkey" PRIMARY KEY (id);


--
-- Name: Surveys Surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Surveys"
    ADD CONSTRAINT "Surveys_pkey" PRIMARY KEY (id);


--
-- Name: Topics Topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Topics"
    ADD CONSTRAINT "Topics_pkey" PRIMARY KEY (id);


--
-- Name: UnreadMessages UnreadMessages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "UnreadMessages"
    ADD CONSTRAINT "UnreadMessages_pkey" PRIMARY KEY (id);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: Votes Votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Votes"
    ADD CONSTRAINT "Votes_pkey" PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: session_staff session_staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY session_staff
    ADD CONSTRAINT session_staff_pkey PRIMARY KEY (id);


--
-- Name: SocialProfileProviderIndex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "SocialProfileProviderIndex" ON "SocialProfiles" USING btree (provider);


--
-- Name: SocialProfileUserIndex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "SocialProfileUserIndex" ON "SocialProfiles" USING btree ("userId");


--
-- Name: UniqEmailContactList; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UniqEmailContactList" ON "ContactListUsers" USING btree ("userId", "accountUserId", "contactListId", "accountId");


--
-- Name: UniqResourceNameByAccount; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UniqResourceNameByAccount" ON "Resources" USING btree ("accountId", name, type);


--
-- Name: account_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_users_email ON "AccountUsers" USING btree (email);


--
-- Name: account_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_users_id ON "AccountUsers" USING btree (id);


--
-- Name: accounts_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_id ON "Accounts" USING btree (id);


--
-- Name: accounts_subdomain; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_subdomain ON "Accounts" USING btree (subdomain);


--
-- Name: accounts_unique_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX accounts_unique_name ON "Accounts" USING btree (subdomain);


--
-- Name: compositeAccountIdMailTemplateBaseIdAndTemplateName; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "compositeAccountIdMailTemplateBaseIdAndTemplateName" ON "MailTemplates" USING btree (name, "AccountId", "MailTemplateBaseId");


--
-- Name: compositeUserIdAndAccountIdAndEmail; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "compositeUserIdAndAccountIdAndEmail" ON "AccountUsers" USING btree (email, "UserId", "AccountId");


--
-- Name: messages_reply_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_reply_id ON "Messages" USING btree ("replyId");


--
-- Name: messages_session_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_session_member_id ON "Messages" USING btree ("sessionMemberId");


--
-- Name: messages_session_topic_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_session_topic_id ON "Messages" USING btree ("sessionTopicId");


--
-- Name: messages_star; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_star ON "Messages" USING btree (star);


--
-- Name: session_members_account_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_members_account_user_id ON "SessionMembers" USING btree ("accountUserId");


--
-- Name: session_members_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_members_session_id ON "SessionMembers" USING btree ("sessionId");


--
-- Name: session_members_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_members_token ON "SessionMembers" USING btree (token);


--
-- Name: session_members_type_of_creation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_members_type_of_creation ON "SessionMembers" USING btree ("typeOfCreation");


--
-- Name: shapes_event_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shapes_event_type ON "Shapes" USING btree ("eventType");


--
-- Name: shapes_session_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shapes_session_member_id ON "Shapes" USING btree ("sessionMemberId");


--
-- Name: shapes_session_topic_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shapes_session_topic_id ON "Shapes" USING btree ("sessionTopicId");


--
-- Name: shapes_uid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shapes_uid ON "Shapes" USING btree (uid);


--
-- Name: social_profiles_provider_provider_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX social_profiles_provider_provider_user_id ON "SocialProfiles" USING btree (provider, "providerUserId");


--
-- Name: uniquePinboardResource; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "uniquePinboardResource" ON "PinboardResources" USING btree ("sessionTopicId", "sessionMemberId");


--
-- Name: unread_messages_message_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unread_messages_message_id ON "UnreadMessages" USING btree ("messageId");


--
-- Name: unread_messages_scope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unread_messages_scope ON "UnreadMessages" USING btree (scope);


--
-- Name: unread_messages_session_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unread_messages_session_member_id ON "UnreadMessages" USING btree ("sessionMemberId");


--
-- Name: unread_messages_session_topic_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unread_messages_session_topic_id ON "UnreadMessages" USING btree ("sessionTopicId");


--
-- Name: userUniqueEmail; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "userUniqueEmail" ON "Users" USING btree (email);


--
-- Name: users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_email ON "Users" USING btree (email);


--
-- Name: users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_id ON "Users" USING btree (id);


--
-- Name: AccountUsers AccountUsers_AccountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AccountUsers"
    ADD CONSTRAINT "AccountUsers_AccountId_fkey" FOREIGN KEY ("AccountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: AccountUsers AccountUsers_UserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AccountUsers"
    ADD CONSTRAINT "AccountUsers_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES "Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Banners Banners_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Banners"
    ADD CONSTRAINT "Banners_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: BrandProjectPreferences BrandProjectPreferences_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "BrandProjectPreferences"
    ADD CONSTRAINT "BrandProjectPreferences_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: BrandProjectPreferences BrandProjectPreferences_brand_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "BrandProjectPreferences"
    ADD CONSTRAINT "BrandProjectPreferences_brand_project_id_fkey" FOREIGN KEY (brand_project_id) REFERENCES "BrandProjects"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Consoles Consoles_audioId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Consoles"
    ADD CONSTRAINT "Consoles_audioId_fkey" FOREIGN KEY ("audioId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Consoles Consoles_fileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Consoles"
    ADD CONSTRAINT "Consoles_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Consoles Consoles_imageId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Consoles"
    ADD CONSTRAINT "Consoles_imageId_fkey" FOREIGN KEY ("imageId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Consoles Consoles_miniSurveyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Consoles"
    ADD CONSTRAINT "Consoles_miniSurveyId_fkey" FOREIGN KEY ("miniSurveyId") REFERENCES "MiniSurveys"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Consoles Consoles_sessionTopicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Consoles"
    ADD CONSTRAINT "Consoles_sessionTopicId_fkey" FOREIGN KEY ("sessionTopicId") REFERENCES "SessionTopics"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Consoles Consoles_videoId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Consoles"
    ADD CONSTRAINT "Consoles_videoId_fkey" FOREIGN KEY ("videoId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ContactListUsers ContactListUsers_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactListUsers"
    ADD CONSTRAINT "ContactListUsers_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE;


--
-- Name: ContactListUsers ContactListUsers_accountUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactListUsers"
    ADD CONSTRAINT "ContactListUsers_accountUserId_fkey" FOREIGN KEY ("accountUserId") REFERENCES "AccountUsers"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ContactListUsers ContactListUsers_contactListId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactListUsers"
    ADD CONSTRAINT "ContactListUsers_contactListId_fkey" FOREIGN KEY ("contactListId") REFERENCES "ContactLists"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ContactListUsers ContactListUsers_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactListUsers"
    ADD CONSTRAINT "ContactListUsers_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ContactLists ContactLists_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ContactLists"
    ADD CONSTRAINT "ContactLists_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DirectMessages DirectMessages_recieverId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "DirectMessages"
    ADD CONSTRAINT "DirectMessages_recieverId_fkey" FOREIGN KEY ("recieverId") REFERENCES "SessionMembers"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DirectMessages DirectMessages_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "DirectMessages"
    ADD CONSTRAINT "DirectMessages_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "SessionMembers"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DirectMessages DirectMessages_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "DirectMessages"
    ADD CONSTRAINT "DirectMessages_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Invites Invites_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Invites"
    ADD CONSTRAINT "Invites_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Invites Invites_accountUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Invites"
    ADD CONSTRAINT "Invites_accountUserId_fkey" FOREIGN KEY ("accountUserId") REFERENCES "AccountUsers"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Invites Invites_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Invites"
    ADD CONSTRAINT "Invites_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Invites Invites_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Invites"
    ADD CONSTRAINT "Invites_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MailTemplateResources MailTemplateResources_mailTemplateId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplateResources"
    ADD CONSTRAINT "MailTemplateResources_mailTemplateId_fkey" FOREIGN KEY ("mailTemplateId") REFERENCES "MailTemplates"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MailTemplateResources MailTemplateResources_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplateResources"
    ADD CONSTRAINT "MailTemplateResources_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MailTemplates MailTemplates_AccountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplates"
    ADD CONSTRAINT "MailTemplates_AccountId_fkey" FOREIGN KEY ("AccountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: MailTemplates MailTemplates_MailTemplateBaseId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplates"
    ADD CONSTRAINT "MailTemplates_MailTemplateBaseId_fkey" FOREIGN KEY ("MailTemplateBaseId") REFERENCES "MailTemplateBases"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: MailTemplates MailTemplates_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MailTemplates"
    ADD CONSTRAINT "MailTemplates_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Messages Messages_sessionMemberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Messages"
    ADD CONSTRAINT "Messages_sessionMemberId_fkey" FOREIGN KEY ("sessionMemberId") REFERENCES "SessionMembers"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Messages Messages_sessionTopicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Messages"
    ADD CONSTRAINT "Messages_sessionTopicId_fkey" FOREIGN KEY ("sessionTopicId") REFERENCES "SessionTopics"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MiniSurveyAnswers MiniSurveyAnswers_miniSurveyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MiniSurveyAnswers"
    ADD CONSTRAINT "MiniSurveyAnswers_miniSurveyId_fkey" FOREIGN KEY ("miniSurveyId") REFERENCES "MiniSurveys"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MiniSurveyAnswers MiniSurveyAnswers_sessionMemberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MiniSurveyAnswers"
    ADD CONSTRAINT "MiniSurveyAnswers_sessionMemberId_fkey" FOREIGN KEY ("sessionMemberId") REFERENCES "SessionMembers"(id) ON UPDATE CASCADE;


--
-- Name: MiniSurveys MiniSurveys_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MiniSurveys"
    ADD CONSTRAINT "MiniSurveys_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MiniSurveys MiniSurveys_sessionTopicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "MiniSurveys"
    ADD CONSTRAINT "MiniSurveys_sessionTopicId_fkey" FOREIGN KEY ("sessionTopicId") REFERENCES "SessionTopics"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PinboardResources PinboardResources_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PinboardResources"
    ADD CONSTRAINT "PinboardResources_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PinboardResources PinboardResources_sessionMemberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PinboardResources"
    ADD CONSTRAINT "PinboardResources_sessionMemberId_fkey" FOREIGN KEY ("sessionMemberId") REFERENCES "SessionMembers"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PinboardResources PinboardResources_sessionTopicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PinboardResources"
    ADD CONSTRAINT "PinboardResources_sessionTopicId_fkey" FOREIGN KEY ("sessionTopicId") REFERENCES "SessionTopics"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Resources Resources_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Resources"
    ADD CONSTRAINT "Resources_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE;


--
-- Name: Resources Resources_accountUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Resources"
    ADD CONSTRAINT "Resources_accountUserId_fkey" FOREIGN KEY ("accountUserId") REFERENCES "AccountUsers"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Resources Resources_topicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Resources"
    ADD CONSTRAINT "Resources_topicId_fkey" FOREIGN KEY ("topicId") REFERENCES "Topics"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SessionMembers SessionMembers_accountUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionMembers"
    ADD CONSTRAINT "SessionMembers_accountUserId_fkey" FOREIGN KEY ("accountUserId") REFERENCES "AccountUsers"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SessionMembers SessionMembers_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionMembers"
    ADD CONSTRAINT "SessionMembers_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SessionResources SessionResources_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionResources"
    ADD CONSTRAINT "SessionResources_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SessionResources SessionResources_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionResources"
    ADD CONSTRAINT "SessionResources_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SessionSurveys SessionSurveys_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionSurveys"
    ADD CONSTRAINT "SessionSurveys_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SessionSurveys SessionSurveys_surveyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionSurveys"
    ADD CONSTRAINT "SessionSurveys_surveyId_fkey" FOREIGN KEY ("surveyId") REFERENCES "Surveys"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SessionTopicsReports SessionTopicsReports_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopicsReports"
    ADD CONSTRAINT "SessionTopicsReports_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SessionTopicsReports SessionTopicsReports_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopicsReports"
    ADD CONSTRAINT "SessionTopicsReports_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SessionTopicsReports SessionTopicsReports_sessionTopicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopicsReports"
    ADD CONSTRAINT "SessionTopicsReports_sessionTopicId_fkey" FOREIGN KEY ("sessionTopicId") REFERENCES "SessionTopics"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SessionTopics SessionTopics_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopics"
    ADD CONSTRAINT "SessionTopics_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SessionTopics SessionTopics_topicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SessionTopics"
    ADD CONSTRAINT "SessionTopics_topicId_fkey" FOREIGN KEY ("topicId") REFERENCES "Topics"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Sessions Sessions_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions"
    ADD CONSTRAINT "Sessions_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Sessions Sessions_brandProjectPreferenceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions"
    ADD CONSTRAINT "Sessions_brandProjectPreferenceId_fkey" FOREIGN KEY ("brandProjectPreferenceId") REFERENCES "BrandProjectPreferences"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Sessions Sessions_brand_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions"
    ADD CONSTRAINT "Sessions_brand_project_id_fkey" FOREIGN KEY (brand_project_id) REFERENCES "BrandProjects"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Sessions Sessions_participantListId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions"
    ADD CONSTRAINT "Sessions_participantListId_fkey" FOREIGN KEY ("participantListId") REFERENCES "ContactLists"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Sessions Sessions_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions"
    ADD CONSTRAINT "Sessions_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Sessions Sessions_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions"
    ADD CONSTRAINT "Sessions_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "BrandProjects"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Sessions Sessions_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Sessions"
    ADD CONSTRAINT "Sessions_type_fkey" FOREIGN KEY (type) REFERENCES "SessionTypes"(name) ON UPDATE CASCADE;


--
-- Name: Shapes Shapes_sessionMemberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Shapes"
    ADD CONSTRAINT "Shapes_sessionMemberId_fkey" FOREIGN KEY ("sessionMemberId") REFERENCES "SessionMembers"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Shapes Shapes_sessionTopicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Shapes"
    ADD CONSTRAINT "Shapes_sessionTopicId_fkey" FOREIGN KEY ("sessionTopicId") REFERENCES "SessionTopics"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SocialProfiles SocialProfiles_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SocialProfiles"
    ADD CONSTRAINT "SocialProfiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"(id) ON UPDATE CASCADE;


--
-- Name: SubscriptionPreferences SubscriptionPreferences_subscriptionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SubscriptionPreferences"
    ADD CONSTRAINT "SubscriptionPreferences_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "Subscriptions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Subscriptions Subscriptions_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Subscriptions"
    ADD CONSTRAINT "Subscriptions_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Subscriptions Subscriptions_subscriptionPlanId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Subscriptions"
    ADD CONSTRAINT "Subscriptions_subscriptionPlanId_fkey" FOREIGN KEY ("subscriptionPlanId") REFERENCES "SubscriptionPlans"(id) ON UPDATE CASCADE;


--
-- Name: SurveyAnswers SurveyAnswers_surveyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SurveyAnswers"
    ADD CONSTRAINT "SurveyAnswers_surveyId_fkey" FOREIGN KEY ("surveyId") REFERENCES "Surveys"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SurveyQuestions SurveyQuestions_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SurveyQuestions"
    ADD CONSTRAINT "SurveyQuestions_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SurveyQuestions SurveyQuestions_surveyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SurveyQuestions"
    ADD CONSTRAINT "SurveyQuestions_surveyId_fkey" FOREIGN KEY ("surveyId") REFERENCES "Surveys"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Surveys Surveys_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Surveys"
    ADD CONSTRAINT "Surveys_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"(id) ON UPDATE CASCADE;


--
-- Name: Surveys Surveys_contactListId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Surveys"
    ADD CONSTRAINT "Surveys_contactListId_fkey" FOREIGN KEY ("contactListId") REFERENCES "ContactLists"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Surveys Surveys_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Surveys"
    ADD CONSTRAINT "Surveys_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: UnreadMessages UnreadMessages_messageId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "UnreadMessages"
    ADD CONSTRAINT "UnreadMessages_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Messages"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UnreadMessages UnreadMessages_sessionMemberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "UnreadMessages"
    ADD CONSTRAINT "UnreadMessages_sessionMemberId_fkey" FOREIGN KEY ("sessionMemberId") REFERENCES "SessionMembers"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UnreadMessages UnreadMessages_sessionTopicId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "UnreadMessages"
    ADD CONSTRAINT "UnreadMessages_sessionTopicId_fkey" FOREIGN KEY ("sessionTopicId") REFERENCES "SessionTopics"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Votes Votes_messageId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Votes"
    ADD CONSTRAINT "Votes_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Messages"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Votes Votes_sessionMemberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Votes"
    ADD CONSTRAINT "Votes_sessionMemberId_fkey" FOREIGN KEY ("sessionMemberId") REFERENCES "SessionMembers"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: session_staff session_staff_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY session_staff
    ADD CONSTRAINT "session_staff_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Sessions"(id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

